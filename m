Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990AbaAQSFp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 13:05:45 -0500
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:40382
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752066AbaAQSFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 13:05:44 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.221;KIP:(null);UIP:(null);IPV:NLI;H:atltwp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(z579ehzbb2dI98dI9371I1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzzz2dh839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh22d0h2336h2438h2461h2487h1155h)
X-WSS-ID: 0MZK4V5-07-JN2-02
X-M-MSG: 
Message-ID: <52D970F1.3090401@amd.com>
Date: Fri, 17 Jan 2014 12:05:37 -0600
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Kim Naru <kim.naru@amd.com>,
        Sherry Hurwitz <sherry.hurwitz@amd.com>
Subject: Re: [PATCH] x86, CPU, AMD: Add workaround for family 16h, erratum
 793
References: <20140114115547.GA29887@pd.tnic> <52D55468.6000000@zytor.com> <20140114153534.GE29865@pd.tnic> <20140114162722.GF29865@pd.tnic> <52D59ACC.3090100@amd.com> <20140114203848.GP29865@pd.tnic> <52D81DB5.7000608@amd.com> <20140117002123.GA9165@khazad-dum.debian.net> <20140117101842.GB8715@pd.tnic> <52D958FC.9020700@zytor.com> <20140117170213.GG8715@pd.tnic> <52D96B9D.703@zytor.com>
In-Reply-To: <52D96B9D.703@zytor.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/17/2014 11:42 AM, H. Peter Anvin wrote:
>
> Hence the question: did an unfixed BIOS ever make it into a shipping
> production system?  Because if it did, we do have a coverage hole.
>
> 	-hpa
>

Right, and the answer to your question is: there is a *chance* it did.. 
 From internal discussions, I could
gather that the fix went into BIOS code earlier for desktop/mobile 
versions than it did for server versions;

So there is a chance production systems (desktop ones) might never see 
the issue, but server ones will, as
BIOSes spun only from now onwards will have the workaround..

-Aravind.

