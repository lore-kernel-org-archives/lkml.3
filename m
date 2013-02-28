Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932659Ab3B1SgU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 13:36:20 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:47894 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755777Ab3B1SgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 13:36:17 -0500
Message-ID: <512FA39D.2060005@wwwdotorg.org>
Date: Thu, 28 Feb 2013 11:36:13 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Ian Lartey <ian@slimlogic.co.uk>
CC: linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, ldewangan@nvidia.com,
        j-keerthy@ti.com, gg@slimlogic.co.uk, cooloney@gmail.com,
        rpurdie@rpsys.net, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH v2 1/2] leds: Add support for Palmas LEDs
References: <1362064909-634-1-git-send-email-ian@slimlogic.co.uk>
In-Reply-To: <1362064909-634-1-git-send-email-ian@slimlogic.co.uk>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2013 08:21 AM, Ian Lartey wrote:
> The Palmas familly of chips has LED support. This is not always muxed
> to output pins so depending on the setting of the mux this driver
> will create the appropriate LED class devices.

> +static struct of_device_id of_palmas_match_tbl[] = {
> +	{ .compatible = "ti,palmas-leds", },
> +	{ /* end */ }
> +};

Is there DT binding documentation for this compatible value somewhere?

