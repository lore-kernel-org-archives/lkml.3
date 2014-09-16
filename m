Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbaIPGn4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 02:43:56 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:44288 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbaIPGnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 02:43:55 -0400
Message-ID: <5417DB9D.8090000@ti.com>
Date: Tue, 16 Sep 2014 12:11:33 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: <cw00.choi@samsung.com>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <myungjoo.ham@samsung.com>,
        <grant.likely@linaro.org>, <rongjun.ying@csr.com>,
        <linux@roeck-us.net>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] Add dt support for extcon gpio driver
References: <1410236078-11713-1-git-send-email-george.cherian@ti.com>
In-Reply-To: <1410236078-11713-1-git-send-email-george.cherian@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

Could you please look into this series?

On 09/09/2014 09:44 AM, George Cherian wrote:
> This series
>          - Convert extcon-gpio driver to use gpiod_* API's
>          - Adds dt support to extcon-gpio driver.
> 	- Add cable name support in case of dt.
>
> George Cherian (5):
>    extcon: gpio: Minor cleanups
>    extcon: gpio: Convert the driver to use gpio desc API's
>    extcon: gpio: Add dt support for the driver.
>    extcon: gpio: Always use  gpio_get_value_cansleep
>    extcon: gpio: Add support for using cable names
>
>   .../devicetree/bindings/extcon/extcon-gpio.txt     |  23 +++++
>   drivers/extcon/extcon-gpio.c                       | 100 +++++++++++++--------
>   include/linux/extcon/extcon-gpio.h                 |   4 +-
>   3 files changed, 89 insertions(+), 38 deletions(-)
>   create mode 100644 Documentation/devicetree/bindings/extcon/extcon-gpio.txt
>
Regards
-George
