Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600Ab3CBHlP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 02:41:15 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1717 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab3CBHlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 02:41:14 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 01 Mar 2013 23:41:06 -0800
Message-ID: <5131ACC3.10803@nvidia.com>
Date: Sat, 2 Mar 2013 13:09:47 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Ian Lartey <ian@slimlogic.co.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCH v2] gpio: palmas: add in GPIO support for palmas charger
References: <1362157598-11458-1-git-send-email-ian@slimlogic.co.uk>
In-Reply-To: <1362157598-11458-1-git-send-email-ian@slimlogic.co.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 March 2013 10:36 PM, Ian Lartey wrote:
> Palmas charger has 16 GPIOs
> add palmas_gpio_[read|write|update] api to take account
> second bank of GPIOs
>
> Signed-off-by: Ian Lartey <ian@slimlogic.co.uk>
> Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
> ---

Looks good.
Acked-by: Laxman Dewangan<ldewangan@nvidia.com>


