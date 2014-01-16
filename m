Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416AbaAPR63 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 12:58:29 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:1944 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750736AbaAPR61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 12:58:27 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.221;KIP:(null);UIP:(null);IPV:NLI;H:atltwp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(z579ehzbb2dI98dI9371Ie6eI4015Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz8275dh1de097hz2dh839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh22d0h2336h2438h2461h2487h1155h)
X-WSS-ID: 0MZI9UY-07-IQP-02
X-M-MSG: 
Message-ID: <52D81DB5.7000608@amd.com>
Date: Thu, 16 Jan 2014 11:58:13 -0600
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Kim Naru <kim.naru@amd.com>,
        Sherry Hurwitz <sherry.hurwitz@amd.com>
Subject: Re: [PATCH] x86, CPU, AMD: Add workaround for family 16h, erratum
 793
References: <20140114114133.GA31473@khazad-dum.debian.net> <20140114115547.GA29887@pd.tnic> <52D55468.6000000@zytor.com> <20140114153534.GE29865@pd.tnic> <20140114162722.GF29865@pd.tnic> <52D59ACC.3090100@amd.com> <20140114203848.GP29865@pd.tnic>
In-Reply-To: <20140114203848.GP29865@pd.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/14/2014 2:38 PM, Borislav Petkov wrote:
> Before you go and do that, just ask internally whether those 
> workarounds are being delivered with AGESA instead. We don't want to 
> have a fix in the kernel for *every* erratum if it can be helped. 
> We're making an exception for this one because it can freeze the core 
> just by executing a locked insn which can be done even in userspace. 

Ok, So looks like workaround for E776 went in early, so it's probably 
safe to assume all BIOSes will have the fix.
The workaround for E792 was checked in this month and *will* be picked 
up by BIOS later..

We might want to still have a software fix for this just in case someone 
uses older BIOSes..

> For future AMD patches, make sure to almost always use tip master, 
> i.e. git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git#master 
> to base your work off of. 

I shall spin a patch on top of tip and send it out soon

Thanks,
-Aravind.

