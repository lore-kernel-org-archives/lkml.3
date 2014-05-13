Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbaEMQlZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 12:41:25 -0400
Received: from yotta.elopez.com.ar ([31.220.24.173]:58534 "EHLO
	yotta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbaEMQlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 12:41:17 -0400
Message-ID: <53724B0E.1010307@elopez.com.ar>
Date: Tue, 13 May 2014 13:40:46 -0300
From: =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Mike Turquette <mturquette@linaro.org>, stern@rowland.harvard.edu,
        kishon@ti.com, hdegoede@redhat.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Boris Brezillon <boris@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com, linux-sunxi@googlegroups.com
Subject: Re: [PATCH RESEND v4 1/8] clk: sunxi: Implement A31 USB clock
References: <1399995862-17788-1-git-send-email-maxime.ripard@free-electrons.com> <1399995862-17788-2-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1399995862-17788-2-git-send-email-maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

El 13/05/14 12:44, Maxime Ripard escribió:
> The A31 USB clock slightly differ from its older counterparts, mostly because
> it has a different gate for each PHY, while the older one had a single gate for
> all the phy.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> Reviewed-by: Hans de Goede <hdegoede@redhat.com>
> Acked-by: Mike Turquette <mturquette@linaro.org>

I have queued this commit in sunxi-clk-for-mike for my 3.16 pull. I have 
also queued the trivial patch below to keep the new compatible documented.

Cheers,

Emilio

--->8---

clk: sunxi: document new A31 USB clock compatible

Support for the USB gates and resets on A31 has been recently added
using a new compatible, so let's document it here.

Signed-off-by: Emilio López <emilio@elopez.com.ar>
---
  Documentation/devicetree/bindings/clock/sunxi.txt | 1 +
  1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/clock/sunxi.txt 
b/Documentation/devicetree/bindings/clock/sunxi.txt
index a5160d8..1f6d3f4 100644
--- a/Documentation/devicetree/bindings/clock/sunxi.txt
+++ b/Documentation/devicetree/bindings/clock/sunxi.txt
@@ -41,6 +41,7 @@ Required properties:
  	"allwinner,sun7i-a20-gmac-clk" - for the GMAC clock module on A20/A31
  	"allwinner,sun4i-a10-usb-clk" - for usb gates + resets on A10 / A20
  	"allwinner,sun5i-a13-usb-clk" - for usb gates + resets on A13
+	"allwinner,sun6i-a31-usb-clk" - for usb gates + resets on A31

  Required properties for all clocks:
  - reg : shall be the control register address for the clock.
-- 
1.9.2
