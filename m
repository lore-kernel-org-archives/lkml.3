Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933575Ab3GVV6k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 17:58:40 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:37790 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932388Ab3GVV6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 17:58:38 -0400
Message-ID: <51EDAB0A.8080601@nvidia.com>
Date: Mon, 22 Jul 2013 14:58:34 -0700
From: Stephen Warren <swarren@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linus.walleij@linaro.org, grant.likely@linaro.org, rob.herring@calxeda.com,
        rob@landley.net, devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        kishon@ti.com, j-keerthy@ti.com, gg@slimlogic.co.uk
Subject: Re: [PATCH V3] gpio: palmas: add dt support
References: <1374469977-8805-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1374469977-8805-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2013 10:12 PM, Laxman Dewangan wrote:
> Add of_device_id table for Palma GPIO to be enable the
> driver from DT file.
> 
> The driver can be registered from DT file as:
> 	palmas: tps65913@58 {
> 		:::::::::::
> 		palmas_gpio: palmas_gpio {
> 			compatible = "ti,palmas-gpio";
> 			gpio-controller;
> 			#gpio-cells = <2>;
> 		};
> 	};
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

> diff --git a/Documentation/devicetree/bindings/gpio/gpio-palmas.txt b/Documentation/devicetree/bindings/gpio/gpio-palmas.txt

> +- #gpio-cells : Should be two.
> +  - first cell is the gpio pin number
> +  - second cell is used to specify optional parameters (unused)

Shouldn't the second cell contain the standard GPIO-related flags such
as bit 0 == active-low?

Aside from that, this binding and indeed the rest of the patch looks
fine to me.
