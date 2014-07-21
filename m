Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbaGUJOM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 05:14:12 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:65207 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256AbaGUJOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 05:14:11 -0400
Message-ID: <53CCD9E1.9000402@linaro.org>
Date: Mon, 21 Jul 2014 11:14:09 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>, linux@maxim.org.za,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
CC: Boris Brezillon <boris@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/14] AT91: PIT: Cleanups and move to drivers/clocksource
References: <1404207208-14513-1-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1404207208-14513-1-git-send-email-maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2014 11:33 AM, Maxime Ripard wrote:
> Hi everyone,
>
> This series cleans up the PIT driver in order for it to not depend on
> anything in mach-at91 anymore, and in the end move it out of
> mach-at91.
>
> Along the way, these patches also do a bit of cleanup.
>
> This has been tested on a G45-EK without DT and an Xplained with DT.

For the entire serie:

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>



-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

