Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220Ab3HZQ6l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 12:58:41 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38889 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202Ab3HZQ6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 12:58:39 -0400
Message-ID: <521B893C.4090109@wwwdotorg.org>
Date: Mon, 26 Aug 2013 10:58:36 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Fabian Vogt <fabian@ritter-vogt.de>
CC: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org,
        linus.walleij@linaro.org, grant.likely@linaro.org, pawel.moll@arm.com,
        rob.herring@calxeda.com, mark.rutland@arm.com, ian.campbell@citrix.com
Subject: Re: [PATCH V4] gpio: New driver for LSI ZEVIO SoCs
References: <1377460180-6192-1-git-send-email-fabian@ritter-vogt.de>
In-Reply-To: <1377460180-6192-1-git-send-email-fabian@ritter-vogt.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2013 01:49 PM, Fabian Vogt wrote:
> This driver supports the GPIO controller found in LSI ZEVIO SoCs.
> It has been successfully tested on a TI nspire CX calculator.

> diff --git a/Documentation/devicetree/bindings/gpio/gpio-zevio.txt b/Documentation/devicetree/bindings/gpio/gpio-zevio.txt

> +Optional:
> +- #ngpios = <32>: Number of GPIOs. Defaults to 32 if absent

I think the GPIO count should be derived from the compatible value
instead. If it turns out there's a clear need for the property, it can
be added later in a backwards-compatible way.
