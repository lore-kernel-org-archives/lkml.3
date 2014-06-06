Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291AbaFFLAX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 07:00:23 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56438 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbaFFLAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 07:00:21 -0400
Message-ID: <53919EF7.2000904@ti.com>
Date: Fri, 6 Jun 2014 16:29:03 +0530
From: Keerthy <a0393675@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Keerthy <j-keerthy@ti.com>
CC: <linux-omap@vger.kernel.org>, <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <linux-kernel@vger.kernel.org>, <sameo@linux.intel.com>,
        <lee.jones@linaro.org>
Subject: Re: [PATCH 0/9] mfd: tps65917: Add support for for TPS65917 PMIC
References: <1401272423-25761-1-git-send-email-j-keerthy@ti.com>
In-Reply-To: <1401272423-25761-1-git-send-email-j-keerthy@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark/Lee Jones,

On Wednesday 28 May 2014 03:50 PM, Keerthy wrote:
> The TPS65917 chip is a power management IC for Portable Navigation Systems
> and Tablet Computing devices. It contains the following components:
>
>   - Regulators.
>   - GPADC.
>   - Over Temperature warning and Shut down.
>
> This patch series adds support for TPS65917 mfd device. At this time only
> the regulator functionality is made available.
>
> The closest drivers are PALMAS series drivers. Hence adapted palmas mfd
> driver to support the tps65917 PMIC.
>
> The register set for SMPSs and LDOs are changed and the ramp delay support
> is also changed. Bit-field defenitions are changed.
> Hence added driver data structures for mfd and regulator drivers
> for palmas and added support for tps65917.
>
> The patches are boot tested on DRA72-EVM.
> The patches are boot tested on OMAP5-UEVM board.

A gentle ping on this rework.

> Keerthy (9):
>    mfd: Add DT bindings for tps65917 PMIC
>    regulator: palmas: Add tps65917 compatible string
>    mfd: palmas: Add tps65917 specific definitions and enums
>    mfd: palmas: Add tps65917 support
>    regulator: palmas: Shift the reg_info structure definition to the
>      header file
>    mfd: palmas: shift the palmas_sleep_requestor_info structure
>      definition to the header file
>    regulator: palmas: Add palmas_pmic_driver_data structure
>    regulator: palmas: add driver data and modularize the probe
>    regulator: palmas: Add tps65917 PMIC support
>
>   Documentation/devicetree/bindings/mfd/palmas.txt   |    2 +
>   .../devicetree/bindings/regulator/palmas-pmic.txt  |    1 +
>   drivers/mfd/palmas.c                               |  228 +++--
>   drivers/regulator/palmas-regulator.c               | 1006 +++++++++++++++-----
>   include/linux/mfd/palmas.h                         |  837 ++++++++++++++++
>   5 files changed, 1770 insertions(+), 304 deletions(-)
>

Regards,
Keerthy
