Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871Ab3HAIxg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 04:53:36 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:64986 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479Ab3HAIxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 04:53:34 -0400
Date: Thu, 1 Aug 2013 09:53:29 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        "'Florian Vaussard'" <florian.vaussard@epfl.ch>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: Re: [PATCH] mfd: twl4030-power: Staticize local functions
Message-ID: <20130801085329.GP13298@lee--X1>
References: <002b01ce8e59$d763f990$862becb0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <002b01ce8e59$d763f990$862becb0$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Aug 2013, Jingoo Han wrote:

> twl4030_power_configure_scripts(), twl4030_power_configure_resources(),
> twl4030_power_probe() are used only in this file.
> 
> Fix the following sparse warnings:
> 
> drivers/mfd/twl4030-power.c:496:5: warning: symbol 'twl4030_power_configure_scripts' was not declared. Should it be static?
> drivers/mfd/twl4030-power.c:512:5: warning: symbol 'twl4030_power_configure_resources' was not declared. Should it be static?
> drivers/mfd/twl4030-power.c:556:5: warning: symbol 'twl4030_power_probe' was not declared. Should it be static?
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/mfd/twl4030-power.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Applied, thanks.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
