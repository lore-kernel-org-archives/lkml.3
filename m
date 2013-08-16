Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794Ab3HPMQI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 08:16:08 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47044 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754072Ab3HPMQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 08:16:06 -0400
Message-ID: <520E17BE.2050008@ti.com>
Date: Fri, 16 Aug 2013 17:44:54 +0530
From: Gururaja Hebbar <gururaja.hebbar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
CC: <akpm@linux-foundation.org>, <khilman@linaro.org>, <tony@atomide.com>,
        <bcousson@baylibre.com>, <rob.herring@calxeda.com>,
        <mark.rutland@arm.com>, <a.zummo@towertech.it>, <rob@landley.net>,
        <grant.likely@linaro.org>, <rtc-linux@googlegroups.com>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <sudhakar.raj@ti.com>
Subject: Re: [PATCH v3 0/2] rtc: omap: update AM335x rtc ip revision
References: <1376653017-21935-1-git-send-email-gururaja.hebbar@ti.com>
In-Reply-To: <1376653017-21935-1-git-send-email-gururaja.hebbar@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Kindly ignore this series. there is mistake/typo because of which it
will not directly apply. I will resend the patch-set.

sorry for the trouble.

regards
Gururaja

On 8/16/2013 5:06 PM, Hebbar, Gururaja wrote:
> The syntax of compatible property in DT is to mention the Most specific
> match to most generic match.
> 
> Since AM335x is the platform with latest IP revision, add it 1st in
> the device id table.
> 
> This way, we can add new matching compatible as 1st and maintain old
> compatible string for backwards compatibility.
> 
> ex:
> 	compatible = "ti,am3352-rtc", "ti,da830-rtc";
> 
> Also, update am335x .dtsi file (am33xx.dtsi) as above.
> 
> Note:
> This is a part of previously submitted patch-set [1]. Out of 4 patches,
> 3 was accepted and 1 got an acceptable NAK. Hence resubmitting only the
> rejected + updated changes.
> 
> Changes in V3:
> 	- As per Mark Rutland's suggestion [2], maintain old compatible
> 	  string and add the new matching string as the 1st compatible.
> 
> Changes in V2:
> 	- Coding style corrections (remove extra space, use lower case
> 	  for hex numbers
> 	- use prefix ARM: for commit subject keeping with arch/arm
> 	  convention)
> 	- use "[AM/am]3352" instead of "[AM/am]335x" to keep the all
> 	  usages in sync.
> 	- Use index defined for struct members so they remain in sync
> 	- Add new compatible to existing one so that when driver
> 	  supports enhanced features of hardware, they are available
> 	  to the user else the basic functionality still works
> 
> [2]
> https://lkml.org/lkml/2013/7/3/74
> [1]
> https://lkml.org/lkml/2013/8/1/442
> 
> Hebbar Gururaja (1):
>   ARM: dts: AM33XX: update rtc node compatibility
> 
> Hebbar, Gururaja (1):
>   rtc: omap: update of_device_id to reflect latest ip revisions
> 
>  arch/arm/boot/dts/am33xx.dtsi |    2 +-
>  drivers/rtc/rtc-omap.c        |    6 +++---
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 

