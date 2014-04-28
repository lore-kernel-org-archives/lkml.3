Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130AbaD1LPI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 07:15:08 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:37413 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333AbaD1LPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 07:15:05 -0400
Date: Mon, 28 Apr 2014 12:14:57 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, Anton Vorontsov <anton@enomsg.org>
Subject: Re: [PATCH part2 5/6] regulator: max14577: Implement SUSPEND mode
 for MAX77836 LDO-s
Message-ID: <20140428111457.GQ21279@lee--X1>
References: <1398264640-12122-1-git-send-email-k.kozlowski@samsung.com>
 <1398264640-12122-6-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1398264640-12122-6-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Apr 2014, Krzysztof Kozlowski wrote:

> The MAX77836 LDO regulators support low power mode. In this mode the
> maximum load current is 5 mA and the quiescent supply current is 1.5 uA.
> 
> This patch adds support for mode REGULATOR_MODE_STANDBY (and NORMAL) to
> LDO regulators by implementing the set_mode() and get_mode() operations.
> However the necessary regulator constraints (valid modes) are not parsed
> by of_regulator_match() so the driver adds them manually to the
> regulator init_data.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/regulator/max14577.c         | 61 ++++++++++++++++++++++++++++++++++--
>  include/linux/mfd/max14577-private.h |  2 ++

For the MFD changes:
  Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
