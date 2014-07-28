Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311AbaG1QSA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 12:18:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56996 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbaG1QR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 12:17:56 -0400
Message-ID: <53D677B1.2000700@suse.de>
Date: Mon, 28 Jul 2014 18:17:53 +0200
From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Michal Simek <michal.simek@xilinx.com>, devicetree@vger.kernel.org,
        Andreas Olofsson <andreas@adapteva.com>, linux-kernel@vger.kernel.org,
        Matteo Vit <matteo.vit@starwaredesign.com>,
        Sean Rickerd <srickerd@suse.com>,
        Punnaiah Choudary Kalluri <punnaia@xilinx.com>,
        linux-arm-kernel@lists.infradead.org,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH v2 00/11] ARM: dts: zynq: Prepare Parallella
References: <1406242820-20140-1-git-send-email-afaerber@suse.de>
In-Reply-To: <1406242820-20140-1-git-send-email-afaerber@suse.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lars-Peter,

Am 25.07.2014 01:00, schrieb Andreas Färber:
> most notably I'm missing 
> ADI ADV7513 and AXI-HDMI support
[...]
> Cc: Lars-Peter Clausen <lars@metafoo.de> (HDMI)

Could you please enlighten us what the status of upstreaming
ADV7511/ADV7513 support is? It is declared "work in progress" here:

http://wiki.analog.com/resources/tools-software/linux-drivers/drm/adv7511

I see some adv7511 V4L bits in drivers/media/i2c/adv7511.c, but no
drivers/gpu/drm/i2c/adv7511_{core,audio}.c as on the xcomm_zynq branch,
nor any devicetree documentation. Patchwork doesn't show any recent
submissions to LKML.

Is any major rework needed for you to get the 3.14.12 based driver upstream?

AXI SPDIF I found in 3.16, as you noticed; what about AXI HDMI? [*]
Is there any work ongoing to get that upstream as well?

Any pointers appreciated.

Thanks,
Andreas

[*]
http://wiki.analog.com/resources/tools-software/linux-drivers/platforms/zynq

-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
