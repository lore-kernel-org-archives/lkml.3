Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496AbaAFQKX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:10:23 -0500
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:33721
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753883AbaAFQKT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:10:19 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(zzbb2dI98dI9371Ic89bh1431J1432Izz1f42h2148h208ch1ee6h1de0h1fdah2149h2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2fh95h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h2336h906i1155h)
Date: Mon, 6 Jan 2014 08:10:03 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <monstr@monstr.eu>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
Subject: Re: [PATCH] devicetree: macb: Document clock properties
References: <1386972205-32733-1-git-send-email-soren.brinkmann@xilinx.com>
 <52AECBFC.5000207@atmel.com>
 <52B2CC2D.9070902@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <52B2CC2D.9070902@monstr.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <031a1a70-93f4-42aa-b7d9-268e3e6624a6@CO9EHSMHS004.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Dec 19, 2013 at 11:36:29AM +0100, Michal Simek wrote:
> On 12/16/2013 10:46 AM, Nicolas Ferre wrote:
> > On 13/12/2013 23:03, Soren Brinkmann :
> >> The macb driver uses the clock bindings. Document the required
> >> properties, especially the driver specific clock-names.
> >>
> >> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > 
> > Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> 
> Has someone taken this patch?
> If not, Rob can you please add it to your tree?

Since nobody responded to Michal's question and I also don't see this in
next yet, I just wanted to check in on the status. Does anybody take
this for 3.14?

	Sören


