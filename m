Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758553AbaDXWnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 18:43:25 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:41581 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755082AbaDXWnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 18:43:21 -0400
Message-ID: <53599370.1070507@ti.com>
Date: Fri, 25 Apr 2014 07:42:56 +0900
From: Milo Kim <milo.kim@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Peter Griffin <peter.griffin@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linaro-kernel@lists.linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Jingoo Han <jg1.han@samsung.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH 09/13] video/backlight: LP8788 needs PWM
References: <1398342509-10243-1-git-send-email-peter.griffin@linaro.org> <1398342509-10243-10-git-send-email-peter.griffin@linaro.org>
In-Reply-To: <1398342509-10243-10-git-send-email-peter.griffin@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2014 09:28 PM, Peter Griffin wrote:
> The LP8788 driver cannot be successfully built if we don't
> enable the PWM subsystem. This patch makes that dependency
> explicit in Kconfig and prevents broken randconfig builds.
>
> Based on Arnd Bergmann patch but split out into seperate
> commits per driver based on feedback.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>

Thanks!

Acked-by: Milo Kim <milo.kim@ti.com>


