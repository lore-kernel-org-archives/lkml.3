Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbaHTUWA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 16:22:00 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:49815 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbaHTUV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 16:21:59 -0400
Message-ID: <53F5037B.3030401@wwwdotorg.org>
Date: Wed, 20 Aug 2014 14:22:19 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mikko Perttunen <mperttunen@nvidia.com>, thierry.reding@gmail.com
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, wni@nvidia.com
Subject: Re: [PATCH v2 1/5] of: Add descriptions of thermtrip properties to
 Tegra PMC bindings
References: <1407933685-12404-1-git-send-email-mperttunen@nvidia.com> <1407933685-12404-2-git-send-email-mperttunen@nvidia.com>
In-Reply-To: <1407933685-12404-2-git-send-email-mperttunen@nvidia.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2014 06:41 AM, Mikko Perttunen wrote:
> Hardware-triggered thermal reset requires configuring the I2C
> reset procedure. This configuration is read from the device tree,
> so document the relevant properties in the binding documentation.

> diff --git a/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-pmc.txt b/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-pmc.txt

> +Optional properties for hardware-triggered thermal reset (inside 'i2c-thermtrip'):
> +- nvidia,pinmux-id : Pinmux used by the hardware when issuing poweroff command.
> +                     Defaults to 0.

We should either enumerate the legal values and what they mean, or 
include a reference to the TRM section which explains the legal values.
