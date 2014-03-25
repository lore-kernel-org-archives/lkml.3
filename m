Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979AbaCYNcL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 09:32:11 -0400
Received: from mail.active-venture.com ([67.228.131.205]:49338 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbaCYNcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 09:32:08 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53318554.7090507@roeck-us.net>
Date: Tue, 25 Mar 2014 06:32:04 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Alex Shi <alex.shi@linaro.org>, mark.hambleton@broadcom.com,
        mark.brown@linaro.org, eduardo.valentin@ti.com, mporter@linaro.org,
        lsk-interest@linaro.org, linaro-kernel@linaro.org
CC: Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH 07/19] hwmon: lm75: expose to thermal fw
 via DT nodes
References: <1395744572-20014-1-git-send-email-alex.shi@linaro.org> <1395744572-20014-8-git-send-email-alex.shi@linaro.org>
In-Reply-To: <1395744572-20014-8-git-send-email-alex.shi@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2014 03:49 AM, Alex Shi wrote:
> From: Eduardo Valentin <eduardo.valentin@ti.com>
>
> This patch adds to lm75 temperature sensor the possibility
> to expose itself as thermal zone device, registered on the
> thermal framework.
>
> The thermal zone is built only if a device tree node
> describing a thermal zone for this sensor is present
> inside the lm75 DT node. Otherwise, the driver behavior
> will be the same.
>
> Note: This patch has also been reviewed by Jean D. He has
> requested to perform a wider inspection of possible
> users of thermal and hwmon interaction API. On the other
> hand, the change on this patch is acceptable on first
> step of overall code change.
>
> Cc: Jean Delvare <khali@linux-fr.org>
> Cc: lm-sensors@lm-sensors.org
> Cc: linux-kernel@vger.kernel.org
> Acked-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
> (cherry picked from commit 22e731838b0e337fed5f16c67aa0b954028dfe93)
>
> Signed-off-by: Alex Shi <alex.shi@linaro.org>

Not entirely sure why you are sending this patch to a public list.
This patch as well as patch 8/19 have already been applied.
Ok, it appears that you plan to apply it to some other branch.
So what ?

Can you clarify ?

Reason for asking is that I don't want to get flooded with e-mail
each time someone applies a patch to some arbitrary branch,
and I end up being confused and looking through the code
trying to figure out what is going on. Whatever it is, your branch
isn't that special that you need to tell the rest of the world
what you are doing.

Thanks,
Guenter

