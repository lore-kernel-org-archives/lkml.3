Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967AbaAQAZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 19:25:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47202 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642AbaAQAZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 19:25:40 -0500
Message-ID: <52D87862.2080904@zytor.com>
Date: Thu, 16 Jan 2014 16:25:06 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
CC: Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Kim Naru <kim.naru@amd.com>,
        Sherry Hurwitz <sherry.hurwitz@amd.com>
Subject: Re: [PATCH] x86, CPU, AMD: Add workaround for family 16h, erratum
 793
References: <20140114114133.GA31473@khazad-dum.debian.net> <20140114115547.GA29887@pd.tnic> <52D55468.6000000@zytor.com> <20140114153534.GE29865@pd.tnic> <20140114162722.GF29865@pd.tnic> <52D59ACC.3090100@amd.com> <20140114203848.GP29865@pd.tnic> <52D81DB5.7000608@amd.com> <20140117002123.GA9165@khazad-dum.debian.net>
In-Reply-To: <20140117002123.GA9165@khazad-dum.debian.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2014 04:21 PM, Henrique de Moraes Holschuh wrote:
> On Thu, 16 Jan 2014, Aravind Gopalakrishnan wrote:
>> We might want to still have a software fix for this just in case
>> someone uses older BIOSes..
> 
> There is no "just in case" when it comes to someone using outdated firmware.
> It is a *given*, except for hardware that is only used in HPC and multiple
> (> 2) socket servers/workstations (which might be the case here, I don't
> know what processors we're talking about).
> 
> The vast majority of PC users will never update their firmware, unless the
> update is automatically offered to them, and sometimes not even in that
> case.
> 

Yes, the real question is: did the broken BIOS ship in production
systems?  We don't care about engineering samples/beta boxes, but once
it is sold as a product, it is real.

	-hpa

