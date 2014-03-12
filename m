Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423AbaCLOYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 10:24:54 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:10808 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbaCLOYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 10:24:51 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-48-53206e306806
Message-id: <1394634287.11860.7.camel@AMDC1943>
Subject: Re: [PATCH v2 1/3] mfd: max8997: use regmap to access registers
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Robert Baldyga <r.baldyga@samsung.com>
Cc: sameo@linux.intel.com, lee.jones@linaro.org, myungjoo.ham@samsung.com,
        cw00.choi@samsung.com, dmitry.torokhov@gmail.com, cooloney@gmail.com,
        rpurdie@rpsys.net, dbaryshkov@gmail.com, dwmw2@infradead.org,
        lgirdwood@gmail.com, broonie@kernel.org, a.zummo@towertech.it,
        paul.gortmaker@windriver.com, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, linux-leds@vger.kernel.org,
        rtc-linux@googlegroups.com, m.szyprowski@samsung.com
Date: Wed, 12 Mar 2014 15:24:47 +0100
In-reply-to: <1394631466-6429-2-git-send-email-r.baldyga@samsung.com>
References: <1394631466-6429-1-git-send-email-r.baldyga@samsung.com>
 <1394631466-6429-2-git-send-email-r.baldyga@samsung.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsVy+t/xy7oGeQrBBoc3WlksuXiV3WLqwyds
	Fkd3TmSyuP7lOavFpCfvmS0OL3rBaDFx5WRmi/tfjzJafLvSwWRx89M3VovLu+awWWx9s47R
	Yu2Ru+wWtxtXsFlc23uc2eLB4Z3sFrt3PWW12N/ZwWhxupvVQdhj56y77B57Jp5k89i8Qstj
	06pONo871/awecw7GeixZ/4PVo++LasYPabP+8nk8XmTnMf6LVuZArijuGxSUnMyy1KL9O0S
	uDJO/ljKWHCEo+LEj53sDYzH2LoYOTkkBEwkzjXuZoewxSQu3FsPFOfiEBJYyijx9chNFgjn
	M6PEpBeXwKp4BfQlent2s4LYwgIeErdPvWcGsdkEjCU2L18CNlVEQEvizsf57CDNzAKHmSX2
	PegAa2ARUJW4smcuI4jNKeAqMa1lJthQIYF6iR8X9rGA2MwC6hKT5i1ihjhJSWJ3eyc7RFxe
	YvOat8wQRwhK/Jh8j2UCo8AsJC2zkJTNQlK2gJF5FaNoamlyQXFSeq6hXnFibnFpXrpecn7u
	JkZIXH7Zwbj4mNUhRgEORiUe3hlK8sFCrIllxZW5hxglOJiVRHiXRSkEC/GmJFZWpRblxxeV
	5qQWH2Jk4uCUamDUOOE457yt46a5/Av2r+q877m7geHjFcfpk4Ny3mU+LTSvsy3Yc8/+q8HH
	1/OUDDduuTY1hTc3VnNCbcDPzOfvJJkbVimfLlrWU7hPl+tfaNf8Cm/eD97TWm81njjVeHya
	+OvOghl7NPsSfOqWTSwt2+/td6/8efHxwPKuy+XLfnE//BM/V36tEktxRqKhFnNRcSIAhkjy
	qKkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-12 at 14:37 +0100, Robert Baldyga wrote:
> This patch modifies max8997 driver and each associated function driver,
> to use regmap instead of operating directly on i2c bus. It will allow to
> simplify IRQ handling using regmap-irq.
> 
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> ---
>  drivers/extcon/extcon-max8997.c     |   31 ++++----
>  drivers/input/misc/max8997_haptic.c |   34 +++++----
>  drivers/leds/leds-max8997.c         |   13 ++--
>  drivers/mfd/Kconfig                 |    1 +
>  drivers/mfd/max8997-irq.c           |   64 +++++++---------
>  drivers/mfd/max8997.c               |  141 ++++++++++++++++-------------------
>  drivers/power/max8997_charger.c     |   33 ++++----
>  drivers/regulator/max8997.c         |   87 +++++++++++----------
>  drivers/rtc/rtc-max8997.c           |   56 +++++++-------
>  include/linux/mfd/max8997-private.h |   17 ++---
>  10 files changed, 228 insertions(+), 249 deletions(-)

Looks fine to me:
Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>


Best regards,
Krzysztof

