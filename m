Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbaCRIBF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 04:01:05 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:52410 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848AbaCRIBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 04:01:00 -0400
Date: Tue, 18 Mar 2014 08:00:55 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Sebastian Reichel <sre@debian.org>
Cc: Sebastian Reichel <sre@ring0.de>, Marek Belisko <marek@goldelico.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-iio@vger.kernel.org
Subject: Re: [PATCHv4 3/7] mfd: twl4030-madc: Cleanup driver
Message-ID: <20140318080055.GC25324@lee--X1>
References: <1394934211-21605-1-git-send-email-sre@debian.org>
 <1394934211-21605-4-git-send-email-sre@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1394934211-21605-4-git-send-email-sre@debian.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Some style fixes in twl4030-madc driver.
> 
> Reported-by: Jonathan Cameron <jic23@kernel.org>
> Reported-by: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Sebastian Reichel <sre@debian.org>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> Acked-by: Jonathan Cameron <jic23@kernel.org>
> Tested-by: Marek Belisko <marek@goldelico.com>
> ---
>  drivers/mfd/twl4030-madc.c       | 145 +++++++++++++++++++--------------------
>  include/linux/i2c/twl4030-madc.h |   2 +-
>  2 files changed, 73 insertions(+), 74 deletions(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
