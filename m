Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834AbaANRrZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 12:47:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53984 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbaANRrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 12:47:23 -0500
Message-ID: <52D5780E.4070700@zytor.com>
Date: Tue, 14 Jan 2014 09:46:54 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Kim Naru <kim.naru@amd.com>,
        Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        Sherry Hurwitz <sherry.hurwitz@amd.com>
Subject: Re: [PATCH] x86, CPU, AMD: Add workaround for family 16h, erratum
 793
References: <20140114114133.GA31473@khazad-dum.debian.net> <20140114115547.GA29887@pd.tnic> <52D55468.6000000@zytor.com> <20140114153534.GE29865@pd.tnic> <20140114162722.GF29865@pd.tnic> <52D56627.9060802@zytor.com> <20140114164208.GK29865@pd.tnic>
In-Reply-To: <20140114164208.GK29865@pd.tnic>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2014 08:42 AM, Borislav Petkov wrote:
> On Tue, Jan 14, 2014 at 08:30:31AM -0800, H. Peter Anvin wrote:
>> Please put MSR_AMD_LS_CFG in msr-index.h or at least at the top of the
>> file,
> 
> Yeah, can we agree on some kind of a rule for msr-index.h? Something
> like the rule for pci.h, for example?
> 
> My only wish is to have all the MSRs at one place so one can search them
> fast. This has been the only thing that I wanted to have in the past,
> from fiddling with MSRs for so long.
> 

That is what msr-index.h is supposed to be.

	-hpa

