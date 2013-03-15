Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab3COFTT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 01:19:19 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:41163 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab3COFTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 01:19:18 -0400
Message-ID: <5142AF55.80708@nvidia.com>
Date: Thu, 14 Mar 2013 23:19:17 -0600
From: Stephen Warren <swarren@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Bill Huang <bilhuang@nvidia.com>
CC: sameo@linux.intel.com, gg@slimlogic.co.uk, ldewangan@nvidia.com,
        broonie@opensource.wolfsonmicro.com, ian@slimlogic.co.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mfd: palmas: Add power off control
References: <1363258680-12600-1-git-send-email-bilhuang@nvidia.com>
In-Reply-To: <1363258680-12600-1-git-send-email-bilhuang@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2013 04:58 AM, Bill Huang wrote:
> Hook up "pm_power_off" to palmas power off routine if there is DT
> property "ti,system-power-controller" defined, so platform which is
> powered by this regulator can be powered off properly.

> diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c

> +	pdata->pm_off = of_property_read_bool(node,
> +			"ti,system-power-controller");

You would need to add that property to the DT binding documentation for
this device.
