Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911AbaARBVj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 20:21:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37416 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779AbaARBVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 20:21:34 -0500
Message-ID: <52D9D6FC.7050100@zytor.com>
Date: Fri, 17 Jan 2014 17:21:00 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Borislav Petkov <bp@alien8.de>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Kim Naru <kim.naru@amd.com>,
        Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        Sherry Hurwitz <sherry.hurwitz@amd.com>
Subject: Re: [PATCH] x86, CPU, AMD: Add workaround for family 16h, erratum
 793
References: <20140114114133.GA31473@khazad-dum.debian.net> <20140114115547.GA29887@pd.tnic> <52D55468.6000000@zytor.com> <20140114153534.GE29865@pd.tnic> <20140114162722.GF29865@pd.tnic> <20140117222806.GB13930@amd.pavel.ucw.cz> <20140117225013.GE14649@pd.tnic> <52D9B408.4020007@zytor.com> <20140118002926.GA22185@amd.pavel.ucw.cz>
In-Reply-To: <20140118002926.GA22185@amd.pavel.ucw.cz>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2014 04:29 PM, Pavel Machek wrote:
> 
> Have you checked your dmesg recently? Normal people don't read
> it... it is just too much of it.
> 
>> Printing a warning is appropriate if we can't actually fix the problem
>> in the OS.  If we actually make the problem go away then we have just
>> done our job and we can be done with it.
> 
> I disagree. Older kernel versions still may have problem, etc.
> 
> We normally do print warnings for problems we work around. We want
> vendors to fix their hardware, too...
> 
> ACPI BIOS Warning (bug): 32/64X FACS address mismatch in FADT -
> 0xBDB5FF40/0x00000000BDB64F40, using 32 (20131115/tbfadt-522)
> [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
> 

You say people don't read their dmesg...
... because there is too much ...
... so let's add more?

What am I missing here?

	-hpa


