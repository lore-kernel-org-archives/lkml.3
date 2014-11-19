Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933881AbaKSV6X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:58:23 -0500
Received: from mail.skyhub.de ([78.46.96.112]:38310 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933867AbaKSV6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:58:19 -0500
Date: Wed, 19 Nov 2014 22:58:14 +0100
From: Borislav Petkov <bp@alien8.de>
To: Dave Jones <davej@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Don Zickus <dzickus@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141119215814.GA4613@pd.tnic>
References: <20141118023930.GA2871@redhat.com>
 <CA+55aFyOTpVQiku0xn=UHnXdYweKHZ5AsEUN9wUvOqH9XX4ENg@mail.gmail.com>
 <20141118145234.GA7487@redhat.com>
 <alpine.DEB.2.11.1411181914020.3909@nanos>
 <20141118215540.GD35311@redhat.com>
 <20141119021902.GA14216@redhat.com>
 <CA+55aFw13opSu6ETXgVo1tjrP+1PLkbsiKewEqRgdBKyBKALWA@mail.gmail.com>
 <20141119145902.GA13387@redhat.com>
 <546D0530.8040800@mit.edu>
 <20141119214743.GA18883@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141119214743.GA18883@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 04:47:43PM -0500, Dave Jones wrote:
> This box is usually pretty solid, but it's been in service as a 24/7
> fuzzing box for over a year now, so it's not outside the realm of
> possibility that this could all be a hardware fault if some memory
> has gone bad or the like.

You could grep old logs for "Hardware Error" and the usual suspects
coming from MCE/EDAC. Also /var/log/mcelog or something like that,
depending on what's running on that box.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
