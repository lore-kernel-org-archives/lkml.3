Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757661AbaCTLT0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 07:19:26 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:63060 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757424AbaCTLTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 07:19:25 -0400
Date: Thu, 20 Mar 2014 04:19:21 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, dwmw2@infradead.org, Angus.Clark@st.com
Subject: Re: [PATCH v6 00/36] mtd: st_spi_fsm: Add new driver
Message-ID: <20140320111921.GR31517@norris-Latitude-E6410>
References: <1395307268-12721-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395307268-12721-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 09:20:32AM +0000, Lee Jones wrote:
> This should be the final version (again) :)
> 
> Version 6:
>   Serviced 3 nits picked up by Brian during final review.
>   
[...]
>  Documentation/devicetree/bindings/mtd/st-fsm.txt |   26 ++
>  arch/arm/boot/dts/stih416-pinctrl.dtsi           |   13 +
>  arch/arm/boot/dts/stih416.dtsi                   |   13 +
>  arch/arm/boot/dts/stih41x-b2020.dtsi             |    1 +
>  arch/arm/boot/dts/stih41x-b2020x.dtsi            |   28 ++
>  drivers/mtd/devices/Kconfig                      |    8 +
>  drivers/mtd/devices/Makefile                     |    1 +
>  drivers/mtd/devices/serial_flash_cmds.h          |   81 +++++
>  drivers/mtd/devices/st_spi_fsm.c                 | 2122 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  9 files changed, 2293 insertions(+)

Pushed patches 1 to 35 to l2-mtd.git. Patch 36 should go via arm-soc, I
believe.

Thanks,
Brian
