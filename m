Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab3A3QqO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 11:46:14 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:36924 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112Ab3A3QqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 11:46:12 -0500
Message-ID: <51094E50.4000302@wwwdotorg.org>
Date: Wed, 30 Jan 2013 09:46:08 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] ARM: ux500: correct typo in pinctrl Device Tree node
References: <1359563102-5934-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1359563102-5934-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2013 09:25 AM, Linus Walleij wrote:
> The preference is to use '-' instead of '_' in compatible strings.

> diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi

>  		pinctrl {
> -			compatible = "stericsson,nmk_pinctrl";
> +			compatible = "stericsson,nmk-pinctrl";

Is there a driver-side patch which this depends on too?

