Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab3IUSG3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 14:06:29 -0400
Received: from mail.active-venture.com ([67.228.131.205]:59701 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397Ab3IUSG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 14:06:27 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <523DE01F.4020607@roeck-us.net>
Date: Sat, 21 Sep 2013 11:06:23 -0700
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
Subject: Re: [PATCHv3 05/16] hwmon: lm75: expose to thermal fw via DT nodes
References: <1379457325-18192-1-git-send-email-eduardo.valentin@ti.com> <1379521314-16959-1-git-send-email-eduardo.valentin@ti.com>
In-Reply-To: <1379521314-16959-1-git-send-email-eduardo.valentin@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2013 09:21 AM, Eduardo Valentin wrote:
> This patch adds to lm75 temperature sensor the possibility
> to expose itself as thermal zone device, registered on the
> thermal framework.
>
> The thermal zone is built only if a device tree node
> describing a thermal zone for this sensor is present
> inside the lm75 DT node. Otherwise, the driver behavior
> will be the same.
>
> Cc: Jean Delvare <khali@linux-fr.org>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: lm-sensors@lm-sensors.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>

Acked-by: Guenter Roeck <linux@roeck-us.net>

I assume this will be sent upstream through the thermal tree ?

Guenter

