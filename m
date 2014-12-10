Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574AbaLJOWK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 09:22:10 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:49212 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757547AbaLJOWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 09:22:07 -0500
Message-ID: <548856D9.7060401@roeck-us.net>
Date: Wed, 10 Dec 2014 06:21:13 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Bartosz Golaszewski <bgolaszewski@baylibre.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        LM Sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH v5 3/3] hwmon: ina2xx: documentation update for new sysfs
 attributes
References: <1418207937-11648-1-git-send-email-bgolaszewski@baylibre.com> <1418207937-11648-4-git-send-email-bgolaszewski@baylibre.com>
In-Reply-To: <1418207937-11648-4-git-send-email-bgolaszewski@baylibre.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020208.5488570F.0014,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 9
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2014 02:38 AM, Bartosz Golaszewski wrote:
> Include the rshunt and avg sysfs attributes for ina2xx in the documentation.
>
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> ---
>   Documentation/hwmon/ina2xx | 10 +++++++---
>   1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/hwmon/ina2xx b/Documentation/hwmon/ina2xx
> index 4223c2d..c100c24 100644
> --- a/Documentation/hwmon/ina2xx
> +++ b/Documentation/hwmon/ina2xx
> @@ -44,6 +44,10 @@ The INA226 monitors both a shunt voltage drop and bus supply voltage.
>   The INA230 is a high or low side current shunt and power monitor with an I2C
>   interface. The INA230 monitors both a shunt voltage drop and bus supply voltage.
>
> -The shunt value in micro-ohms can be set via platform data or device tree.
> -Please refer to the Documentation/devicetree/bindings/i2c/ina2xx.txt for bindings
> -if the device tree is used.
> +The shunt value in micro-ohms can be set via platform data or device tree in
> +compile-time or via the shunt_resistor attribute in sysfs in run-time. Please
> +refer to the Documentation/devicetree/bindings/i2c/ina2xx.txt for bindings if
> +the device tree is used.
> +
> +The averaging rate of INA226 and INA230 can be changed via the avg_rate sysfs
> +attribute. The available rates are: 1, 4, 16, 64, 128, 256, 512 and 1024.
>
Please merge the documentation updates into the actual patches as appropriate.

Guenter

