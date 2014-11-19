Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532AbaKSW7O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:59:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755043AbaKSW7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 17:59:13 -0500
Date: Wed, 19 Nov 2014 17:18:42 -0500
From: Dave Jones <davej@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Don Zickus <dzickus@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141119221842.GA21963@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Andy Lutomirski <luto@amacapital.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Don Zickus <dzickus@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	the arch/x86 maintainers <x86@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
References: <CA+55aFyOTpVQiku0xn=UHnXdYweKHZ5AsEUN9wUvOqH9XX4ENg@mail.gmail.com>
 <20141118145234.GA7487@redhat.com>
 <alpine.DEB.2.11.1411181914020.3909@nanos>
 <20141118215540.GD35311@redhat.com>
 <20141119021902.GA14216@redhat.com>
 <CA+55aFw13opSu6ETXgVo1tjrP+1PLkbsiKewEqRgdBKyBKALWA@mail.gmail.com>
 <20141119145902.GA13387@redhat.com>
 <546D0530.8040800@mit.edu>
 <20141119214743.GA18883@redhat.com>
 <20141119215814.GA4613@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141119215814.GA4613@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 10:58:14PM +0100, Borislav Petkov wrote:
 > On Wed, Nov 19, 2014 at 04:47:43PM -0500, Dave Jones wrote:
 > > This box is usually pretty solid, but it's been in service as a 24/7
 > > fuzzing box for over a year now, so it's not outside the realm of
 > > possibility that this could all be a hardware fault if some memory
 > > has gone bad or the like.
 > 
 > You could grep old logs for "Hardware Error" and the usual suspects
 > coming from MCE/EDAC. Also /var/log/mcelog or something like that,
 > depending on what's running on that box.

Nothing, but it wouldn't be the first time I'd seen a hardware fault
that didn't raise an MCE.

	Dave

