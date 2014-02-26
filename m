Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635AbaBZICo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 03:02:44 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:43876 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbaBZICk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 03:02:40 -0500
Date: Wed, 26 Feb 2014 08:02:32 +0000
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
Subject: Re: [RFCv3 5/7] mfd: twl4030-madc: Use twl_i2c_read/write_u16 for 16
 bit registers
Message-ID: <20140226080232.GF9195@lee--X1>
References: <1393193271-16717-1-git-send-email-sre@debian.org>
 <1393374270-20079-1-git-send-email-sre@debian.org>
 <1393374270-20079-6-git-send-email-sre@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1393374270-20079-6-git-send-email-sre@debian.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Simplify reading and writing of 16 bit TWL registers in the
> driver by using twl_i2c_read_u16 and twl_i2c_write_u16.
> 
> Signed-off-by: Sebastian Reichel <sre@debian.org>
> ---
>  drivers/mfd/twl4030-madc.c | 39 ++++++++-------------------------------
>  1 file changed, 8 insertions(+), 31 deletions(-)

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
