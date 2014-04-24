Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424AbaDXWoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 18:44:21 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37905 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932268AbaDXWoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 18:44:13 -0400
Message-ID: <535993A7.3060504@ti.com>
Date: Fri, 25 Apr 2014 07:43:51 +0900
From: Milo Kim <milo.kim@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Peter Griffin <peter.griffin@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linaro-kernel@lists.linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Jingoo Han <jg1.han@samsung.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH 12/13] video/backlight: LP855X needs PWM
References: <1398342509-10243-1-git-send-email-peter.griffin@linaro.org> <1398342509-10243-13-git-send-email-peter.griffin@linaro.org>
In-Reply-To: <1398342509-10243-13-git-send-email-peter.griffin@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2014 09:28 PM, Peter Griffin wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>
> The LP855X driver cannot be successfully built if we don't
> enable the PWM subsystem. This patch makes that dependency
> explicit in Kconfig and prevents broken randconfig builds.
>

Thanks!

Acked-by: Milo Kim <milo.kim@ti.com>


