Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbaKJUiX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 15:38:23 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:56590 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752512AbaKJUiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 15:38:21 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+m4Y0pO/fiIp8CBXjdcvCb
Date: Mon, 10 Nov 2014 12:37:36 -0800
From: Tony Lindgren <tony@atomide.com>
To: Sebastian Reichel <sre@kernel.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCHv3 0/4] [media] si4713 DT binding
Message-ID: <20141110203736.GW31454@atomide.com>
References: <1415651684-3894-1-git-send-email-sre@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415651684-3894-1-git-send-email-sre@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Reichel <sre@kernel.org> [141110 12:36]:
> Hi,
> 
> This is the third revision of the si4713 radio transmitter DT support
> patchset needed for the Nokia N900.
> 
> Changes since PATCHv2:
>  * Dropped patches 1-4, which have been accepted
>  * Patch 1 has been updated according to Sakari's comments
>  * Patch 3-4 are unchanged
> 
> Apart from that you marked Patch 2 as not applicable last time [0].
> Normally the DT binding documentation is taken by the subsystem
> maintainer together with the driver changes. You can see the details
> in Documentation/devicetree/bindings/submitting-patches.txt
> 
> For Patch 3 feedback from Tony is needed. I think the simplest solution
> would be to merge it via the media tree (assuming, that the boardcode
> is not yet removed in 3.19).

Yes just acked it thanks.

Tony
 
> [0] https://patchwork.linuxtv.org/patch/26506/
> 
> -- Sebastian
> 
> Sebastian Reichel (4):
>   [media] si4713: add device tree support
>   [media] si4713: add DT binding documentation
>   ARM: OMAP2: RX-51: update si4713 platform data
>   [media] si4713: cleanup platform data
> 
>  Documentation/devicetree/bindings/media/si4713.txt | 30 ++++++++++
>  arch/arm/mach-omap2/board-rx51-peripherals.c       | 69 ++++++++++------------
>  drivers/media/radio/si4713/radio-platform-si4713.c | 28 ++-------
>  drivers/media/radio/si4713/si4713.c                | 31 +++++++++-
>  drivers/media/radio/si4713/si4713.h                |  6 ++
>  include/media/radio-si4713.h                       | 30 ----------
>  include/media/si4713.h                             |  4 +-
>  7 files changed, 103 insertions(+), 95 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/media/si4713.txt
>  delete mode 100644 include/media/radio-si4713.h
> 
> -- 
> 2.1.1
> 
