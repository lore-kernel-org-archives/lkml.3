Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab3I0Io1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 04:44:27 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:47015 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934Ab3I0IoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 04:44:22 -0400
Message-ID: <52454563.9000208@linaro.org>
Date: Fri, 27 Sep 2013 10:44:19 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
CC: Rob Herring <rob.herring@calxeda.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 1/6] cpuidle: calxeda: add support to use PSCI calls
References: <1380248694-13388-1-git-send-email-robherring2@gmail.com> <1380248694-13388-2-git-send-email-robherring2@gmail.com>
In-Reply-To: <1380248694-13388-2-git-send-email-robherring2@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2013 04:24 AM, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
>
> This updates the Calxeda cpuidle driver to use PSCI calls to powergate
> cores. This is needed to enable cpuidle for the ECX-2000.
>
> This could possibly become a generic PSCI driver, but there are no other
> PSCI users in the kernel other than mach-virt.
>
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: linux-pm@vger.kernel.org

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

