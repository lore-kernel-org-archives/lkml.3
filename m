Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab3HUXd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 19:33:57 -0400
Received: from co1ehsobe005.messaging.microsoft.com ([216.32.180.188]:9633
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752116Ab3HUXdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 19:33:55 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI936eI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
Message-ID: <1377128031.5029.75.camel@snotra.buserror.net>
Subject: Re: [PATCH v7 1/3] DMA: Freescale: revise device tree binding
 document
From: Scott Wood <scottwood@freescale.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: <hongbo.zhang@freescale.com>, <vinod.koul@intel.com>, <djbw@fb.com>,
        <leoli@freescale.com>, <linuxppc-dev@lists.ozlabs.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date: Wed, 21 Aug 2013 18:33:51 -0500
In-Reply-To: <52154976.2010204@wwwdotorg.org>
References: <1375094944-3343-1-git-send-email-hongbo.zhang@freescale.com>
	  <1375094944-3343-2-git-send-email-hongbo.zhang@freescale.com>
	  <5215402E.70007@wwwdotorg.org>
	 <1377125156.5029.40.camel@snotra.buserror.net>
	 <52154976.2010204@wwwdotorg.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-21 at 17:12 -0600, Stephen Warren wrote:
> OK, if there's some alternative run-time way of enabling chip-specific
> quirking, it's probably fine to remove the extra compatible values.
> 
> Now, that does rather assume that this DMA IP block will only ever be
> used within SoCs that have that SVR concept, but perhaps if that's ever
> not the case, we can simply go back to requiring extra compatible values
> in those specific cases?

The only situation I can see where SVR would be absent is if we were to
integrate this device into an ARM chip, in which case I'd expect there
to be some equivalent way to find the SoC identification.  If the driver
knows what SoC version it expects, it will know the way that that SoC
advertises its version.

-Scott



