Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751195AbaKDGOj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 01:14:39 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:38403 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753AbaKDGOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 01:14:36 -0500
Message-ID: <54586E34.6090602@ti.com>
Date: Tue, 4 Nov 2014 11:42:04 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Felipe Balbi <balbi@ti.com>, <myungjoo.ham@samsung.com>,
        <cw00.choi@samsung.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>, <nsekhar@ti.com>,
        <grant.likely@linaro.org>
Subject: Re: [PATCH 0/4] extcon: gpio: add DT support
References: <1415032350-8459-1-git-send-email-balbi@ti.com>
In-Reply-To: <1415032350-8459-1-git-send-email-balbi@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe et al.

Another series was posted by removing the platform support.
https://lkml.org/lkml/2014/10/14/244

I guess I forgot to copy linux-omap.



On 11/03/2014 10:02 PM, Felipe Balbi wrote:
> Hi,
>
> this series has been tested with v3.18-rc2 with a
> yet-to-be-released board (called X15). That board
> is DT-only and we use extcon-gpio to decide which
> USB mode should be used (host or peripheral).
>
> George Cherian (4):
>    extcon: gpio: Convert the driver to use gpio desc API's
>    extcon: gpio: Add dt support for the driver.
>    extcon: gpio: Always use gpio_get_value_cansleep
>    extcon: gpio: Add support for using cable names
>
>   .../devicetree/bindings/extcon/extcon-gpio.txt     | 23 ++++++
>   drivers/extcon/extcon-gpio.c                       | 93 ++++++++++++++--------
>   2 files changed, 84 insertions(+), 32 deletions(-)
>   create mode 100644 Documentation/devicetree/bindings/extcon/extcon-gpio.txt
>

