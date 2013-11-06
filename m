Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913Ab3KFAPT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 19:15:19 -0500
Received: from mail-db9lp0251.outbound.messaging.microsoft.com ([213.199.154.251]:1521
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755885Ab3KFAPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 19:15:17 -0500
X-Forefront-Antispam-Report: CIP:66.35.236.232;KIP:(null);UIP:(null);IPV:NLI;H:SJ-ITEXEDGE02.altera.priv.altera.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zz98dI936eI1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h17326ah8275dh1de097h186068hz2fh2a8h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1fe8h1ff5h2218h2216h1155h)
Message-ID: <1383696907.618.1.camel@linux-builds1>
Subject: Re: [PATCH 0/3 - V2] Introducing Device Tree Overlays
From: Dinh Nguyen <dinguyen@altera.com>
To: Guenter Roeck <linux@roeck-us.net>
CC: Pantelis Antoniou <panto@antoniou-consulting.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Date: Tue, 5 Nov 2013 18:15:07 -0600
In-Reply-To: <20131105190633.GA21178@roeck-us.net>
References: <1383676898-29819-1-git-send-email-panto@antoniou-consulting.com>
	 <20131105190633.GA21178@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-OriginatorOrg: altera.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pantelis,

On Tue, 2013-11-05 at 11:06 -0800, Guenter Roeck wrote:
> On Tue, Nov 05, 2013 at 08:41:35PM +0200, Pantelis Antoniou wrote:
> > The following patchset introduces Device Tree overlays, a method
> > of dynamically altering the kernel's live Device Tree, along with
> > a generic interface to use it in a board agnostic manner.
> > 
> Hi Pantelis,
> 
> great to see this going. I'll apply the patches to our tree and test.

+1. Alan and I will also test this with the FPGA framework.

Thanks,
Dinh
> 
> I have a couple of patches on top of yours:
> - export overlay functions
> - declare of_free_overlay_info as static inline if OF is undefined.
> - ignore PCI devices when inserting or removing overlays 
>   [ Based on the idea that PCI/PCIe ports are handled by the PCI subsystem ]
> 
> I'll rebase those to the new version of your patches and send it out
> after I get it all working.
> 
> Thanks,
> Guenter
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



