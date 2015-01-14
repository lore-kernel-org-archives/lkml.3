Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbbANJwH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 04:52:07 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:36395 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753870AbbANJwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 04:52:04 -0500
Message-ID: <54B63C07.9010301@ti.com>
Date: Wed, 14 Jan 2015 15:21:03 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>, Mark Brown <broonie@kernel.org>,
        <linux@arm.linux.org.uk>, <arnd@arndb.de>, <vinod.koul@intel.com>,
        <khilman@deeprootsystems.com>
CC: Liam Girdwood <lgirdwood@gmail.com>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>, <ulf.hansson@linaro.org>,
        <chris@printf.net>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mmc@vger.kernel.org>, <linux-spi@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Tony Lindgren <tony@atomide.com>,
        <dmaengine@vger.kernel.org>
Subject: Re: [PATCH 0/3] ARM: edma: Correct header file usage
References: <1417084891-17990-1-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1417084891-17990-1-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 November 2014 04:11 PM, Peter Ujfalusi wrote:
> Hi,
> 
> The linux/platform_data/edma.h file was used for API definition as well, which
> is not correct since the header should only contain platform data related
> structures, defines, etc.

I would like to queue this series through ARM-SoC for v3.20 with Mark's
and Ulf's acks added. I know its not the complete clean-up everyone
wanted to see but I also know Peter working on doing the complete
clean-up as well. So we are firmly on the path to removing
arch/arm/common/edma.c.

Thanks,
Sekhar

