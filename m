Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521Ab3AMJE4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 04:04:56 -0500
Received: from ns368539.ovh.net ([94.23.35.102]:54771 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab3AMJEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 04:04:52 -0500
X-Greylist: delayed 412 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Jan 2013 04:04:52 EST
Message-ID: <50F27714.3060906@free-electrons.com>
Date: Sun, 13 Jan 2013 09:57:56 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Prashant Gaikwad <pgaikwad@nvidia.com>
CC: mturquette@linaro.org, swarren@nvidia.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, rob.herring@calxeda.com,
        linux@prisktech.co.nz, josh.cartwright@ni.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/7] clk: add common of_clk_init() function
References: <1357282858-2112-1-git-send-email-pgaikwad@nvidia.com>
In-Reply-To: <1357282858-2112-1-git-send-email-pgaikwad@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prashant,

On 04/01/2013 08:00, Prashant Gaikwad wrote:
> Modify of_clk_init function so that it will determine which
> driver to initialize based on device tree instead of each driver
> registering to it.
> 
> Based on a similar patch for drivers/irqchip by Thomas Petazzoni and
> drivers/clocksource by Stephen Warren.

I finally had some time to test your changes on sunxi, and you can add
for patches 1 and 3:
Acked-by: Maxime Ripard <maxime.ripard@anandra.org>

Maxime

-- 
Maxime Ripard, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
