Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab3JLBTS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 21:19:18 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:46937
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751742Ab3JLBTQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 21:19:16 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 6
X-BigFish: VS6(z551bizda00h1432Idc73hzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5hbe9i2184m1155h)
From: Chen Peter-B29397 <B29397@freescale.com>
To: Arokux X <arokux@gmail.com>, Kishon Vijay Abraham I <kishon@ti.com>
CC: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: RE: When USB PHY framework should be used?
Thread-Topic: When USB PHY framework should be used?
Thread-Index: AQHOxe30+5PawpueH02NmOVoF/xQS5nvBGYAgAC8l4CAAIUEsA==
Date: Sat, 12 Oct 2013 01:19:08 +0000
Message-ID: <F281D0F91ED19E4D8E63A7504E8A6498040BEDD1@039-SN2MPN1-021.039d.mgd.msft.net>
References: <CAPNxggauvgpWR5HK4Z-Osv7-mB-Tf3-vfyXQDMiTx08K2M=nJQ@mail.gmail.com>
	<52579592.1020209@ti.com>
 <CAPNxgga6xSPrGPWnKJuamMURQdrX0_Hkhx_ZDdS2dcUgs72EKw@mail.gmail.com>
In-Reply-To: <CAPNxgga6xSPrGPWnKJuamMURQdrX0_Hkhx_ZDdS2dcUgs72EKw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: BCxR Cchv OzlX QV8H UcRZ oFry oXFv vcm7 y4H/ 2B2c 5cmW
 AAr1gw== ADH6Cw== AD0j9g== AEDDKw==
 AFwOLw==;8;YQByAG8AawB1AHgAQABnAG0AYQBpAGwALgBjAG8AbQA7AGIAYQBsAGIAaQBAAHQAaQAuAGMAbwBtADsAZwByAGUAZwBrAGgAQABsAGkAbgB1AHgAZgBvAHUAbgBkAGEAdABpAG8AbgAuAG8AcgBnADsAawBpAHMAaABvAG4AQAB0AGkALgBjAG8AbQA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBsAGkAbgB1AHgALQB1AHMAYgBAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAbQBhAHgAaQBtAGUALgByAGkAcABhAHIAZABAAGYAcgBlAGUALQBlAGwAZQBjAHQAcgBvAG4AcwAuAGMAbwBtADsAcwB0AGUAcgBuAEAAcgBvAHcAbABhAG4AZAAuAGgAYQByAHYAYQByAGQALgBlAGQAdQA=;Sosha1_v1;7;{A6D856D9-62C7-4DB2-AC87-684E8DF751BB};YgAyADkAMwA5ADcAQABmAHIAZQBlAHMAYwBhAGwAZQAuAGMAbwBtAA==;Sat,
 12 Oct 2013 01:18:49
 GMT;UgBFADoAIABXAGgAZQBuACAAVQBTAEIAIABQAEgAWQAgAGYAcgBhAG0AZQB3AG8AcgBrACAAcwBoAG8AdQBsAGQAIABiAGUAIAB1AHMAZQBkAD8A
x-cr-puzzleid: {A6D856D9-62C7-4DB2-AC87-684E8DF751BB}
x-originating-ip: [10.192.242.175]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> 
> > I think you should have a wrapper driver to EHCI/OHCI to handle this
> reset.
> 
> Thank you Kishon and Peter for the quick replies. Is there any good
> example of such a wrapper driver in the kernel already?
> 
 
chipidea, dwc3, etc.


