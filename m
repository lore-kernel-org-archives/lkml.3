Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbbAVIhj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 03:37:39 -0500
Received: from mail-ig0-f174.google.com ([209.85.213.174]:41966 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbbAVIhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 03:37:31 -0500
MIME-Version: 1.0
In-Reply-To: <2015012211022773401912@163.com>
References: <1421518516-26976-1-git-send-email-b.galvani@gmail.com>
	<1421518516-26976-2-git-send-email-b.galvani@gmail.com>
	<CACRpkdZ6CX1XePa0sOY-0B9He9jYPNLqUtkk3LEGeT6eSQW9ew@mail.gmail.com>
	<2015012211022773401912@163.com>
Date: Thu, 22 Jan 2015 09:37:30 +0100
Message-ID: <CACRpkdb=9K62kJbQHWK=Bqfcz7zVckKcF3riC-9RDdd-8vG7bg@mail.gmail.com>
Subject: Re: Re: [PATCH v4 1/3] pinctrl: add driver for Amlogic Meson SoCs
From: Linus Walleij <linus.walleij@linaro.org>
To: 48169172 <48169172@163.com>
Cc: "b.galvani" <b.galvani@gmail.com>, Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Victor Wan <victor.wan@amlogic.com>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Kumar Gala <galak@codeaurora.org>,
        "carlo@caione.org" <carlo@caione.org>,
        Jerry Cao <jerry.cao@amlogic.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 4:02 AM, 48169172 <48169172@163.com> wrote:

> Hi  linus,
> How could I get these code?

git clone git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
git checkout devel

Yours,
Linus Walleij
