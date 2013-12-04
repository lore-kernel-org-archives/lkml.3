Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932538Ab3LDOyP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 09:54:15 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:39544 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254Ab3LDOyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 09:54:14 -0500
Message-ID: <529F421F.3000705@linaro.org>
Date: Wed, 04 Dec 2013 15:54:23 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Thomas Gleixner'" <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "'Magnus Damm'" <damm@igel.co.jp>,
        "'Paul Mundt'" <lethal@linux-sh.org>,
        "'Simon Horman'" <horms+renesas@verge.net.au>,
        "'Laurent Pinchart'" <laurent.pinchart+renesas@ideasonboard.com>
Subject: Re: [PATCH 1/2] clocksource: sh_tmu: remove unnecessary platform_set_drvdata()
References: <000001ceeff3$e867a100$b936e300$%han@samsung.com>
In-Reply-To: <000001ceeff3$e867a100$b936e300$%han@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2013 07:50 AM, Jingoo Han wrote:
> The driver core clears the driver data to NULL after device_release
> or on probe failure. Thus, it is not needed to manually clear the
> device driver data to NULL.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> Acked-by: Simon Horman <horms+renesas@verge.net.au>
> ---

Applied to my tree for 3.14.



-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

