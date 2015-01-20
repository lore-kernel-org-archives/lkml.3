Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbbATJ7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 04:59:16 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:47101 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbbATJ7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 04:59:09 -0500
MIME-Version: 1.0
In-Reply-To: <1421518516-26976-2-git-send-email-b.galvani@gmail.com>
References: <1421518516-26976-1-git-send-email-b.galvani@gmail.com>
	<1421518516-26976-2-git-send-email-b.galvani@gmail.com>
Date: Tue, 20 Jan 2015 10:59:08 +0100
Message-ID: <CACRpkdZ6CX1XePa0sOY-0B9He9jYPNLqUtkk3LEGeT6eSQW9ew@mail.gmail.com>
Subject: Re: [PATCH v4 1/3] pinctrl: add driver for Amlogic Meson SoCs
From: Linus Walleij <linus.walleij@linaro.org>
To: Beniamino Galvani <b.galvani@gmail.com>
Cc: Carlo Caione <carlo@caione.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
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

On Sat, Jan 17, 2015 at 7:15 PM, Beniamino Galvani <b.galvani@gmail.com> wrote:

> This is a driver for the pinmux and GPIO controller available in
> Amlogic Meson SoCs. It currently supports only Meson8, however the
> common code should be generic enough to work also for other SoCs after
> having defined the proper set of functions and groups.
>
> GPIO interrupts are not supported at the moment due to lack of
> documentation.
>
> Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>

Patch applied. Great work Beniamino!

Yours,
Linus Walleij
