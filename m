Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275Ab3BDJCt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 04:02:49 -0500
Received: from mail.skyhub.de ([78.46.96.112]:44417 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754207Ab3BDJCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 04:02:46 -0500
Date: Mon, 4 Feb 2013 10:02:37 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 4/4] x86, 32-bit: Drop new_cpu_data
Message-ID: <20130204090237.GB13909@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
References: <1359908079-10469-1-git-send-email-bp@alien8.de>
 <1359908079-10469-5-git-send-email-bp@alien8.de>
 <510EF65D.4020602@zytor.com>
 <20130204052725.GA13909@pd.tnic>
 <562c8dd4-6665-4365-8eb4-33e77e6f6798@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <562c8dd4-6665-4365-8eb4-33e77e6f6798@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 03, 2013 at 09:44:02PM -0800, H. Peter Anvin wrote:
> boot_cpu_data is ok for things that are indeed universally valid
> across. That does not include CPUID level, for one.

Wait a minute, hold the phone! :-)

Are you saying that CPUID_EAX(0) could return different values in %eax
on the *same* system with mixed-silicon steppings? Or even on an uniform
system?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
