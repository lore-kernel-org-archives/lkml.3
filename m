Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab3IZBrk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 21:47:40 -0400
Received: from mail-db8lp0187.outbound.messaging.microsoft.com ([213.199.154.187]:41797
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751827Ab3IZBrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 21:47:35 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI936eI1453Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
Message-ID: <1380159992.24959.248.camel@snotra.buserror.net>
Subject: Re: [PATCH v10 2/3] DMA: Freescale: Add new 8-channel DMA engine
 device tree nodes
From: Scott Wood <scottwood@freescale.com>
To: Hongbo Zhang <hongbo.zhang@freescale.com>
CC: Stephen Warren <swarren@wwwdotorg.org>, <mark.rutland@arm.com>,
        <devicetree@vger.kernel.org>, <ian.campbell@citrix.com>,
        <pawel.moll@arm.com>, <vinod.koul@intel.com>,
        <linux-kernel@vger.kernel.org>, <rob.herring@calxeda.com>,
        <djbw@fb.com>, <linuxppc-dev@lists.ozlabs.org>
Date: Wed, 25 Sep 2013 20:46:32 -0500
In-Reply-To: <52429252.10009@freescale.com>
References: <1379499333-4745-1-git-send-email-hongbo.zhang@freescale.com>
	 <1379499333-4745-3-git-send-email-hongbo.zhang@freescale.com>
	 <524074A7.7000001@wwwdotorg.org> <524169E3.7030408@freescale.com>
	 <5241CC60.5070204@wwwdotorg.org> <52429252.10009@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-25 at 15:35 +0800, Hongbo Zhang wrote:
> By the way, I know maybe it is difficult, but why not introduce a 
> document of maintaining rules for the dt binding docs? we have dedicated 
> maintainers for this part now. Description language from one submitter 
> cannot satisfy every reviewer/maintainer, for a reg property, is it 
> necessary to say "offset and length",

Don't say "offset and length".  It's both redundant with the base
definition of the reg property, and overly specific because it makes
assumptions about how the parent node's ranges are set up (sometimes we
want to be that specific, but usually not).

> to say "how many entries", to say "register functions and even names"?

If there's more than one
entry/resource/whatever-we-decide-to-call-it-but-let's-pick-something-canonical, then say how many there are and what each one means.

-Scott



