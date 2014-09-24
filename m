Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbaIXOf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:35:29 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:54197 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbaIXOfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:35:25 -0400
Date: Wed, 24 Sep 2014 15:35:19 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH on mfd-regulator-power-v3.17] charger: max14577: Fix
 build breakage when compiled as module
Message-ID: <20140924143519.GJ32069@lee--X1>
References: <1411560006-16471-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1411560006-16471-1-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2014, Krzysztof Kozlowski wrote:

> The charger's module device table used the same name as regulator driver
> causing a build break when charger was compiled as a module:
> 
> drivers/power/max14577_charger.c:598:1: error: ‘__mod_platform__max14577_regulator_id_device_table’ aliased to undefined symbol ‘max14577_regulator_id’
> make[2]: *** [drivers/power/max14577_charger.o] Error 1
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> ---
>  drivers/power/max14577_charger.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

I have fixed this up into the original set and re-sent the
pull-request.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
