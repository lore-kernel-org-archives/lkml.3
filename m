Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709AbaK0NpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 08:45:00 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:63539 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbaK0No6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 08:44:58 -0500
MIME-Version: 1.0
In-Reply-To: <1416168856-12747-2-git-send-email-b.galvani@gmail.com>
References: <1416168856-12747-1-git-send-email-b.galvani@gmail.com>
	<1416168856-12747-2-git-send-email-b.galvani@gmail.com>
Date: Thu, 27 Nov 2014 14:44:58 +0100
Message-ID: <CACRpkdajw44K0jj2F=Fsf6CY4FDyuuj8Y3b3uiUeK6_1FwJcSw@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] pinctrl: meson: add device tree bindings documentation
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

> Add device tree bindings documentation for Amlogic Meson pin and GPIO
> controller.
>
> Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>

This is exactly how I want modern pin controller bindings to look
when combining groups and functions, so patch applied.

Now let me look at the driver!

Yours,
Linus Walleij
