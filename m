Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab3A2LAA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 06:00:00 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:60487 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912Ab3A2K7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 05:59:55 -0500
MIME-Version: 1.0
In-Reply-To: <1359445134-13323-2-git-send-email-manishv.b@ti.com>
References: <1359445134-13323-1-git-send-email-manishv.b@ti.com>
	<1359445134-13323-2-git-send-email-manishv.b@ti.com>
Date: Tue, 29 Jan 2013 11:59:54 +0100
Message-ID: <CACRpkdbf7TwrjfT2rhqQFGc3yh_Nt117RtzQO2y6g5Ddx5Ay_w@mail.gmail.com>
Subject: Re: [PATCH V2 1/6] pinctrl: pinctrl-single: use arch_initcall and module_exit
From: Linus Walleij <linus.walleij@linaro.org>
To: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        davinci-linux-open-source@linux.davincidsp.com, anilkumar@ti.com,
        tony@atomide.com, hs@denx.de, broonie@opensource.wolfsonmicro.com,
        sameo@linux.intel.com, khilman@deeprootsystems.com, nsekhar@ti.com,
        linux@arm.linux.org.uk, rob@landley.net, rob.herring@calxeda.com,
        grant.likely@secretlab.ca
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 8:38 AM, Vishwanathrao Badarkhe, Manish
<manishv.b@ti.com> wrote:

> Currently, I2C driver gets probed before pinctrl driver.
> To achieve I2C pin muxing via pinctrl driver before I2C
> probe get called, register pinctrl driver in arch_initcall.
> Also, add module_exit to unregister pinctrl driver.
>
> Signed-off-by: Vishwanathrao Badarkhe, Manish <manishv.b@ti.com>

So your I2C driver is not returning -EPROBE_DEFER
if it cannot find its pins?

Hm, well I can live with this, if Tony ACKs it.

Yours,
Linus Walleij
