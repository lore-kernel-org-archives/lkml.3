Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965065Ab3DIIHJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 04:07:09 -0400
Received: from mga03.intel.com ([143.182.124.21]:64510 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964889Ab3DIIHC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 04:07:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,437,1363158000"; 
   d="scan'208";a="283541348"
Date: Tue, 9 Apr 2013 10:06:53 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Fabio Porcedda <fabio.porcedda@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-ide@vger.kernel.org,
        lm-sensors@lm-sensors.org, linux-input@vger.kernel.org,
        linux-fbdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 08/10] drivers: mfd: use module_platform_driver_probe()
Message-ID: <20130409080653.GG24058@zurbaran>
References: <1363266691-15757-1-git-send-email-fabio.porcedda@gmail.com>
 <1363266691-15757-10-git-send-email-fabio.porcedda@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363266691-15757-10-git-send-email-fabio.porcedda@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fabio,

On Thu, Mar 14, 2013 at 02:11:29PM +0100, Fabio Porcedda wrote:
> This patch converts the drivers to use the
> module_platform_driver_probe() macro which makes the code smaller and
> a bit simpler.
> 
> Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: linux-arm-kernel@lists.infradead.org
> ---
>  drivers/mfd/davinci_voicecodec.c | 12 +-----------
>  drivers/mfd/htc-pasic3.c         | 13 +------------
>  2 files changed, 2 insertions(+), 23 deletions(-)
Jingoo Han sent a larger patchset to convert many MFD drivers to
module_platform_driver_probe(), including htc-pasic3 and davinci_voicecodec.

See my mfd-next tree for more details.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
