Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601AbaKSJuq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 04:50:46 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:46243 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791AbaKSJuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 04:50:44 -0500
Message-ID: <546C67F1.1000005@linaro.org>
Date: Wed, 19 Nov 2014 10:50:41 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Beniamino Galvani <b.galvani@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Carlo Caione <carlo@caione.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clocksource: meson6: Select CLKSRC_MMIO
References: <1416125020-5715-1-git-send-email-b.galvani@gmail.com>
In-Reply-To: <1416125020-5715-1-git-send-email-b.galvani@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2014 09:03 AM, Beniamino Galvani wrote:
> Select CLKSRC_MMIO when the meson6_timer driver is enabled since it
> depends on clocksource MMIO functions.
>
> Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>

patch queued for 3.19

Thanks !

   -- Daniel


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

