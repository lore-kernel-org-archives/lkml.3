Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbaCKG4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 02:56:30 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:34180 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbaCKG41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 02:56:27 -0400
Date: Tue, 11 Mar 2014 06:56:22 +0000
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
Subject: Re: [PATCHv3 2/9] mfd: twl4030-madc: Add DT support and convert to
 IIO framework
Message-ID: <20140311065622.GF2839@lee--X1>
References: <1394472329-15485-1-git-send-email-sre@debian.org>
 <1394472329-15485-3-git-send-email-sre@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1394472329-15485-3-git-send-email-sre@debian.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This converts twl4030-madc module to use the Industrial IO ADC
> framework and adds device tree support.
> 
> Signed-off-by: Sebastian Reichel <sre@debian.org>
> Tested-by: Marek Belisko <marek@goldelico.com>
> ---
>  drivers/mfd/twl4030-madc.c | 127 +++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 116 insertions(+), 11 deletions(-)

It looks as if my previous review comments have been addressed.
  Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
