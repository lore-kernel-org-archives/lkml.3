Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592AbaIXJNu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:13:50 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:41254 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653AbaIXJMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:12:07 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdaTfnsOv4htpE+3mxRWFeSd6TtbQbb48oPFEvwE+WHQCw@mail.gmail.com>
References: <1410790185-31101-1-git-send-email-mika.westerberg@linux.intel.com>
	<1410790185-31101-2-git-send-email-mika.westerberg@linux.intel.com>
	<CACRpkdaTfnsOv4htpE+3mxRWFeSd6TtbQbb48oPFEvwE+WHQCw@mail.gmail.com>
Date: Wed, 24 Sep 2014 11:12:06 +0200
Message-ID: <CACRpkdb=arjF3Y8rHnweh6pfSpsdBHOrPdVrZxf+k8FvRxZMWA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] gpio: Add support for Intel Cherryview/Braswell
 GPIO controller
From: Linus Walleij <linus.walleij@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Alexandre Courbot <gnurou@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Alan Cox <alan@linux.intel.com>, Ning Li <ning.li@intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 11:10 AM, Linus Walleij
<linus.walleij@linaro.org> wrote:

> Read Documentation/pinctrl.txt and rewrite the entire driver to
> use pin control, and generic pin config like everyone else.

NB: this will be a dual-mode driver exposing *both* a pin control
*and* a gpiochip interface. Look at other drivers in drivers/pinctrl
for examples, e.g. drivers/pinctrl/qcom/*

Yours,
Linus Walleij
