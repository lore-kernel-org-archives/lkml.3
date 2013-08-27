Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab3H0UJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 16:09:45 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:41808 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076Ab3H0UJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 16:09:43 -0400
Message-ID: <521D0783.9000804@wwwdotorg.org>
Date: Tue, 27 Aug 2013 14:09:39 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Fabian Vogt <fabian@ritter-vogt.de>
CC: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org,
        linus.walleij@linaro.org, grant.likely@linaro.org, pawel.moll@arm.com,
        rob.herring@calxeda.com, mark.rutland@arm.com, ian.campbell@citrix.com
Subject: Re: [PATCH V5] gpio: New driver for LSI ZEVIO SoCs
References: <1377541133-7427-1-git-send-email-fabian@ritter-vogt.de>
In-Reply-To: <1377541133-7427-1-git-send-email-fabian@ritter-vogt.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2013 12:18 PM, Fabian Vogt wrote:
> This driver supports the GPIO controller found in LSI ZEVIO SoCs.
> It has been successfully tested on a TI nspire CX calculator.

What changed in v5 (or indeed any other versions?)

> diff --git a/Documentation/devicetree/bindings/gpio/gpio-zevio.txt b/Documentation/devicetree/bindings/gpio/gpio-zevio.txt

> +Zevio GPIO controller
> +
> +Required properties:
> +- compatible = "lsi,zevio-gpio"
> +- reg = <BASEADDR SIZE>

Perhaps this should say:

reg: Contains a single register specifier for the GPIO module's registers.

> +- #gpio-cells = <2>

This should describe what those cells are. For example perhaps:

#gpio-cells. Must be 2. The first cell is the GPIO number. The second
  cell is used to specify optional parameters:
  - bit 0 specifies polarity (0 for normal, 1 for inverted)
