Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751157AbaLPELt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 23:11:49 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:59977 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbaLPELs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 23:11:48 -0500
Date: Tue, 16 Dec 2014 12:11:10 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Stefan Agner <stefan@agner.ch>
Cc: kernel@pengutronix.de, linux@roeck-us.net, arnd@arndb.de, sre@kernel.org,
        fkan@apm.com, mark.rutland@arm.com, dbaryshkov@gmail.com,
        dwmw2@infradead.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/3] power: reset: vf610 system reset controller
Message-ID: <20141216041109.GY2411@dragon>
References: <1417540320-2385-1-git-send-email-stefan@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417540320-2385-1-git-send-email-stefan@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 06:11:57PM +0100, Stefan Agner wrote:
> Stefan Agner (3):
>   power: reset: adjust priority of simple syscon reboot driver
>   ARM: dts: vf610: add system reset controller and syscon-reboot
>   ARM: imx_v6_v7_defconfig: add POWER_RESET_SYSCON

Applied the last two.

Shawn
