Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300AbaLRInV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 03:43:21 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:61540 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbaLRInT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 03:43:19 -0500
Date: Thu, 18 Dec 2014 08:43:14 +0000
From: Peter Griffin <peter.griffin@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        a.zummo@towertech.it, kernel@stlinux.com, rtc-linux@googlegroups.com,
        devicetree@vger.kernel.org, wim@iguana.be, arnd@arndb.de,
        linux@roeck-us.net, linux-watchdog@vger.kernel.org
Subject: Re: [STLinux Kernel] [PATCH 6/8] watchdog: st_wdt: Add new driver
 for ST's LPC Watchdog
Message-ID: <20141218084314.GA25901@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1418834727-1602-1-git-send-email-lee.jones@linaro.org>
 <1418834727-1602-7-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418834727-1602-7-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Wed, 17 Dec 2014, Lee Jones wrote:

> Signed-off-by: David Paris <david.paris@st.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/watchdog/Kconfig  |  13 ++
>  drivers/watchdog/Makefile |   1 +
>  drivers/watchdog/st_wdt.c | 323 ++++++++++++++++++++++++++++++++++++++++++++++

You don't have a patch which adds the new files created in this series into
the STI section of the MAINTAINERS file?

regards,

Peter.
