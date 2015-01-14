Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636AbbANWlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 17:41:23 -0500
Received: from mail.skyhub.de ([78.46.96.112]:47276 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753314AbbANWlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 17:41:20 -0500
Date: Wed, 14 Jan 2015 23:41:15 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/11] x86: entry_64.S: always allocate complete "struct
 pt_regs"
Message-ID: <20150114224115.GF6902@pd.tnic>
References: <1421272101-16847-1-git-send-email-dvlasenk@redhat.com>
 <CAK1hOcMZKpcLVWffv_L9DoaK5-V2qSHkm3N2=mo8wKZfEMLyWA@mail.gmail.com>
 <CALCETrXBKnXzhhtvv5o_jAQnShrBJ1v8jCn7dXhDdiOOcZAp+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALCETrXBKnXzhhtvv5o_jAQnShrBJ1v8jCn7dXhDdiOOcZAp+g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 02:29:39PM -0800, Andy Lutomirski wrote:
> I need to go through Linus' and everyone else's comments on that to
> figure out what to do first.

Right, we want to take it slow and be conservative here - entry_XX.S is
not a joke.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
