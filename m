Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab3LOTFB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 14:05:01 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:57103 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab3LOTE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 14:04:59 -0500
Date: Sun, 15 Dec 2013 14:04:54 -0500
From: Tejun Heo <tj@kernel.org>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Oliver Schinagl <oliver@schinagl.nl>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Olliver Schinagl <oliver+list@schinagl.nl>, grant.likely@linaro.org,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, dev@linux-sunxi.org,
        maxime.ripard@free-electrons.com, ijc@hellion.org.uk,
        Richard Zhu <r65037@freescale.com>, Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH 2/3] ARM: sunxi: Add an ahci-platform compatible AHCI
 driver for the Allwinner SUNXi series of SoCs
Message-ID: <20131215190454.GA32509@htj.dyndns.org>
References: <1386159055-10264-1-git-send-email-oliver@schinagl.nl>
 <1386159055-10264-3-git-send-email-oliver@schinagl.nl>
 <20131204123708.GD3158@htj.dyndns.org>
 <529F2677.3070208@schinagl.nl>
 <20131204131402.GG3158@htj.dyndns.org>
 <529F2B41.8090009@schinagl.nl>
 <20131204132312.GH3158@htj.dyndns.org>
 <20131206100117.59609a8a@skate>
 <52A19502.1090409@schinagl.nl>
 <52ADFC44.7040003@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52ADFC44.7040003@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Hans.

On Sun, Dec 15, 2013 at 08:00:20PM +0100, Hans de Goede wrote:
> I think it would be a good idea to merge ahci upstream using the
> ahci_imx.c method for now. You already indicated that you were not against
> doing that for now.

Well, the thing is nothing actually happened since ahci_imx got
merged, so I'm wondering maybe there isn't enough pressure.

> Oliver is working on getting a cleaner solution for this, but doing this
> properly takes tinme, and we would like to move forward with getting
> sunxi ahci support upstream in the mean time.
> 
> So if it is ok with you we would like to move forward with the version
> initially posted. Therefor I would like to request you to review it
> (glossing over the platform device instantiating a platform device
> approach for now), and provide us with feedback so that we can do a v2
> and start moving this towards the mainline kernel.

We still have some time left before the next merge window and if it's
really necessary, I can submit drivers post -rc1 too, so I'd still
*much* prefer doing it properly rather than creating more drivers
which would need to be cleaned up later.

Thanks.

-- 
tejun
