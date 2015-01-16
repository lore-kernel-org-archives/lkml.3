Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbbAPLOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 06:14:17 -0500
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:19995 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbbAPLOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 06:14:15 -0500
X-ME-Helo: beldin
X-ME-Date: Fri, 16 Jan 2015 12:14:14 +0100
X-ME-IP: 109.214.23.205
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
Cc: "balbi\@ti.com" <balbi@ti.com>,
        "Dinh Nguyen \(dinguyen\@opensource.altera.com\)" 
	<dinguyen@opensource.altera.com>,
        "lyz\@rock-chips.com" <lyz@rock-chips.com>,
        "linus.walleij\@linaro.org" <linus.walleij@linaro.org>,
        "linux-usb\@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: phy: make GPIOs optional for the generic phy
References: <A2CA0424C0A6F04399FB9E1CD98E0304845078CE@US01WEMBX2.internal.synopsys.com>
X-URL: http://belgarath.falguerolles.org/
Date: Fri, 16 Jan 2015 12:14:07 +0100
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E0304845078CE@US01WEMBX2.internal.synopsys.com>
	(Paul Zimmerman's message of "Thu, 15 Jan 2015 02:45:12 +0000")
Message-ID: <878uh3x9j4.fsf@free.fr>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Zimmerman <Paul.Zimmerman@synopsys.com> writes:

> From 47bd18e210fecf701d493c27884e13c69bc449ea Mon Sep 17 00:00:00 2001
> From: Paul Zimmerman <paulz@synopsys.com>
> Date: Wed, 14 Jan 2015 18:15:58 -0800
> Subject: [PATCH] usb: phy: make GPIOs optional for the generic phy
>
> The use of GPIOs should be optional for the generic phy, otherwise
> the Altera SOCFPGA platform at least is broken.
>
> Fixes breakage caused by a combination of e9f2cefb0cd "usb: phy: 
> generic: migrate to gpio_desc" and 135b3c4304d "usb: dwc2: platform: 
> add generic PHY framework support".
>
> Signed-off-by: Paul Zimmerman <paulz@synopsys.com>
Reviewed-by: Robert Jarzmik <robert.jarzmik@free.fr>

Cheers.

--
Robert
