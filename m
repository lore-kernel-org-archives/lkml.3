Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210AbaDVLku (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 07:40:50 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:57002 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589AbaDVLks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 07:40:48 -0400
MIME-Version: 1.0
In-Reply-To: <1397137966-30818-3-git-send-email-boris.brezillon@free-electrons.com>
References: <1397137966-30818-1-git-send-email-boris.brezillon@free-electrons.com>
	<1397137966-30818-3-git-send-email-boris.brezillon@free-electrons.com>
Date: Tue, 22 Apr 2014 13:40:47 +0200
Message-ID: <CACRpkdYQ-rTTNukXA+6vN=Qce1hxYSBc5MNM84dYweBu52jfag@mail.gmail.com>
Subject: Re: [PATCH v3 2/7] pinctrl: sunxi: disable clk when failing to probe
 pin controller
From: Linus Walleij <linus.walleij@linaro.org>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        =?UTF-8?Q?Emilio_L=C3=B3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>, Chen-Yu Tsai <wens@csie.org>,
        Hans de Goede <hdegoede@redhat.com>, Shuge <shuge@allwinnertech.com>,
        kevin@allwinnertech.com,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dev@linux-sunxi.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 3:52 PM, Boris BREZILLON
<boris.brezillon@free-electrons.com> wrote:

> Disable the clk when failing to probe the pin controller device.
>
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>

Patch applied with Maxime's ACK.

Yours,
Linus Walleij
