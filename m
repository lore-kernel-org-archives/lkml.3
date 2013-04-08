Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936462Ab3DHOaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 10:30:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:31762 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936441Ab3DHOaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 10:30:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,432,1363158000"; 
   d="scan'208";a="314727387"
Date: Mon, 8 Apr 2013 16:30:08 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] mfd: Add device tree bindings for Arizona class devices
Message-ID: <20130408143008.GA21256@zurbaran>
References: <1364938728-7732-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364938728-7732-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Tue, Apr 02, 2013 at 10:38:48PM +0100, Mark Brown wrote:
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  Documentation/devicetree/bindings/mfd/arizona.txt |   62 ++++++++++++++++++++
>  drivers/mfd/arizona-core.c                        |   64 +++++++++++++++++++++
>  drivers/mfd/arizona-i2c.c                         |   10 +++-
>  drivers/mfd/arizona-spi.c                         |   10 +++-
>  drivers/mfd/arizona.h                             |   12 ++++
>  5 files changed, 154 insertions(+), 4 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/mfd/arizona.txt
This is the one that caused the build failure around missing
arizona_of_get_core_pdata() with !CONFIG_OF, so I'm leaving this one out for
now.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
