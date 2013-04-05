Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162919Ab3DEUnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 16:43:18 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59884 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162808Ab3DEUnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 16:43:13 -0400
Date: Fri, 5 Apr 2013 22:43:06 +0200
From: Borislav Petkov <bp@alien8.de>
To: Julien Tinnes <jln@google.com>
Cc: Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        "kernel-hardening@lists.openwall.com" 
	<kernel-hardening@lists.openwall.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Matthew Garrett <mjg@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Eric Northup <digitaleric@google.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Will Drewry <wad@chromium.org>
Subject: Re: [PATCH 3/3] x86: kernel base offset ASLR
Message-ID: <20130405204306.GA14092@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Julien Tinnes <jln@google.com>, Kees Cook <keescook@chromium.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
	Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
	Matthew Garrett <mjg@redhat.com>,
	Matt Fleming <matt.fleming@intel.com>,
	Eric Northup <digitaleric@google.com>,
	Dan Rosenberg <drosenberg@vsecurity.com>,
	Will Drewry <wad@chromium.org>
References: <1365106055-22939-1-git-send-email-keescook@chromium.org>
 <1365106055-22939-4-git-send-email-keescook@chromium.org>
 <20130405144954.GC29290@pd.tnic>
 <CAKyRK=iEXpq9KnG_VJMYW-tpBxU_2TGaO_hZRkNY=J+7SNoQkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAKyRK=iEXpq9KnG_VJMYW-tpBxU_2TGaO_hZRkNY=J+7SNoQkA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 05, 2013 at 01:19:39PM -0700, Julien Tinnes wrote:
> I think it'd be perfectly ok for OOPS to print out the kernel base.

Yeah, ok, this still would need some massaging of the oops output per
script, but it shouldn't be a big problem.

Also, you probably need to make clear in the oops itself that the
addresses have been randomized. Or, is the mere presence of kernel base
going to imply that?

> Restricting access to these oopses becomes a different problem
> (privilege separation). Some existing sandboxes (Chromium, vsftpd,
> openssh..) are already defending against it.

Ok.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
