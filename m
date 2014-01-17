Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbaAQWwX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 17:52:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36076 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177AbaAQWwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 17:52:21 -0500
Message-ID: <52D9B408.4020007@zytor.com>
Date: Fri, 17 Jan 2014 14:51:52 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Pavel Machek <pavel@ucw.cz>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Kim Naru <kim.naru@amd.com>,
        Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        Sherry Hurwitz <sherry.hurwitz@amd.com>
Subject: Re: [PATCH] x86, CPU, AMD: Add workaround for family 16h, erratum
 793
References: <20140114114133.GA31473@khazad-dum.debian.net> <20140114115547.GA29887@pd.tnic> <52D55468.6000000@zytor.com> <20140114153534.GE29865@pd.tnic> <20140114162722.GF29865@pd.tnic> <20140117222806.GB13930@amd.pavel.ucw.cz> <20140117225013.GE14649@pd.tnic>
In-Reply-To: <20140117225013.GE14649@pd.tnic>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2014 02:50 PM, Borislav Petkov wrote:
> On Fri, Jan 17, 2014 at 11:28:06PM +0100, Pavel Machek wrote:
>> Would it make sense to printk() a warning?
> 
> No because people come and start bitching about their dmesg containing
> a warning and whether their hardware is b0rked without even reading the
> actual words.
> 

Printing a warning is appropriate if we can't actually fix the problem
in the OS.  If we actually make the problem go away then we have just
done our job and we can be done with it.

	-hpa

