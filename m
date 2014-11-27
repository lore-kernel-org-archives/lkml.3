Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586AbaK0Nt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 08:49:27 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:43869 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbaK0NtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 08:49:25 -0500
MIME-Version: 1.0
In-Reply-To: <1416168856-12747-4-git-send-email-b.galvani@gmail.com>
References: <1416168856-12747-1-git-send-email-b.galvani@gmail.com>
	<1416168856-12747-4-git-send-email-b.galvani@gmail.com>
Date: Thu, 27 Nov 2014 14:49:24 +0100
Message-ID: <CACRpkdYSvOqvttyZw0wgDhXxRGR0KLfRi-N5Ym5W4mzjAV9=Eg@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] ARM: meson: select PINCTRL_MESON and ARCH_REQUIRE_GPIOLIB
From: Linus Walleij <linus.walleij@linaro.org>
To: Beniamino Galvani <b.galvani@gmail.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Carlo Caione <carlo@caione.org>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jerry Cao <jerry.cao@amlogic.com>,
        Victor Wan <victor.wan@amlogic.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 16, 2014 at 9:14 PM, Beniamino Galvani <b.galvani@gmail.com> wrote:

> Make sure that the Meson pinctrl driver is built whenever Meson
> support is enabled.
>
> Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

(Given we can merge the pinctrl driver)

Please merge this through the ARM SoC tree.

Yours,
Linus Walleij
