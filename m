Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab3IUSHV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 14:07:21 -0400
Received: from mail.active-venture.com ([67.228.131.205]:59709 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab3IUSHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 14:07:19 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <523DE053.7010502@roeck-us.net>
Date: Sat, 21 Sep 2013 11:07:15 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Eduardo Valentin <eduardo.valentin@ti.com>
CC: swarren@wwwdotorg.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ian.campbell@citrix.com, rob.herring@calxeda.com, rui.zhang@intel.com,
        wni@nvidia.com, grant.likely@linaro.org, durgadoss.r@intel.com,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH 06/16] hwmon: tmp102: expose to thermal fw via DT nodes
References: <1379457245-17810-1-git-send-email-eduardo.valentin@ti.com> <1379521390-17404-1-git-send-email-eduardo.valentin@ti.com>
In-Reply-To: <1379521390-17404-1-git-send-email-eduardo.valentin@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2013 09:23 AM, Eduardo Valentin wrote:
> This patch adds to tmp102 temperature sensor the possibility
> to expose itself as thermal zone device, registered on the
> thermal framework.
>
> The thermal zone is built only if a device tree node
> describing a thermal zone for this sensor is present
> inside the tmp102 DT node. Otherwise, the driver behavior
> will be the same.
>
> Cc: Jean Delvare <khali@linux-fr.org>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: lm-sensors@lm-sensors.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>

Acked-by: Guenter Roeck <linux@roeck-us.net>


