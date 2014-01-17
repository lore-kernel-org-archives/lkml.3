Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746AbaAQKSx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 05:18:53 -0500
Received: from mail.skyhub.de ([78.46.96.112]:32968 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051AbaAQKSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 05:18:50 -0500
Date: Fri, 17 Jan 2014 11:18:42 +0100
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Kim Naru <kim.naru@amd.com>,
        Sherry Hurwitz <sherry.hurwitz@amd.com>
Subject: Re: [PATCH] x86, CPU, AMD: Add workaround for family 16h, erratum 793
Message-ID: <20140117101842.GB8715@pd.tnic>
References: <20140114114133.GA31473@khazad-dum.debian.net>
 <20140114115547.GA29887@pd.tnic>
 <52D55468.6000000@zytor.com>
 <20140114153534.GE29865@pd.tnic>
 <20140114162722.GF29865@pd.tnic>
 <52D59ACC.3090100@amd.com>
 <20140114203848.GP29865@pd.tnic>
 <52D81DB5.7000608@amd.com>
 <20140117002123.GA9165@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140117002123.GA9165@khazad-dum.debian.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 10:21:24PM -0200, Henrique de Moraes Holschuh wrote:
> On Thu, 16 Jan 2014, Aravind Gopalakrishnan wrote:
> > We might want to still have a software fix for this just in case
> > someone uses older BIOSes..
> 
> There is no "just in case" when it comes to someone using outdated firmware.
> It is a *given*, except for hardware that is only used in HPC and multiple
> (> 2) socket servers/workstations (which might be the case here, I don't
> know what processors we're talking about).
> 
> The vast majority of PC users will never update their firmware, unless the
> update is automatically offered to them, and sometimes not even in that
> case.

We also cannot carry *every* erratum workaround in the kernel just
because people don't update firmware. Firmware is becoming ubiquitous,
sadly, and because of that, admins should provision for firmware
upgrades too.

Besides, *even* if we put *all* errata fixes in the kernel, you'd need
to update it anyway and reboot. In this case, you can just as well
update your firmware instead, which involves that same reboot.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
