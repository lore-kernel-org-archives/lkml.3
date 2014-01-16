Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554AbaAPSK4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 13:10:56 -0500
Received: from mail.skyhub.de ([78.46.96.112]:43014 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbaAPSKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 13:10:52 -0500
Date: Thu, 16 Jan 2014 19:10:44 +0100
From: Borislav Petkov <bp@alien8.de>
To: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Kim Naru <kim.naru@amd.com>,
        Sherry Hurwitz <sherry.hurwitz@amd.com>
Subject: Re: [PATCH] x86, CPU, AMD: Add workaround for family 16h, erratum 793
Message-ID: <20140116181044.GG22492@pd.tnic>
References: <20140114114133.GA31473@khazad-dum.debian.net>
 <20140114115547.GA29887@pd.tnic>
 <52D55468.6000000@zytor.com>
 <20140114153534.GE29865@pd.tnic>
 <20140114162722.GF29865@pd.tnic>
 <52D59ACC.3090100@amd.com>
 <20140114203848.GP29865@pd.tnic>
 <52D81DB5.7000608@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52D81DB5.7000608@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 11:58:13AM -0600, Aravind Gopalakrishnan wrote:
> We might want to still have a software fix for this just in case
> someone uses older BIOSes..

Are you saying there are F16h BIOSes out there which might not have the
fix?

Also, for PCI config space fixes, take a look at
arch/x86/kernel/quirks.c

Also, code in arch/x86/kernel/amd_nb.c could come in handy, especially
if you have multiple F16h sockets configurations.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
