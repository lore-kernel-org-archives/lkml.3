Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381AbaICG5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 02:57:36 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:48191 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077AbaICG5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 02:57:34 -0400
MIME-Version: 1.0
In-Reply-To: <1409161588-19417-2-git-send-email-alvin.chen@intel.com>
References: <1409161588-19417-1-git-send-email-alvin.chen@intel.com>
	<1409161588-19417-2-git-send-email-alvin.chen@intel.com>
Date: Wed, 3 Sep 2014 08:57:33 +0200
Message-ID: <CACRpkdYA2QeqLefJN3zVW3QJATP+wEvfPtSyPTqvaFZc6D3FUw@mail.gmail.com>
Subject: Re: [PATCH 1/3] GPIO: gpio-dwapb: Enable platform driver binding to
 MFD driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Weike Chen <alvin.chen@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jamie Iles <jamie@jamieiles.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Boon Leong Ong <boon.leong.ong@intel.com>,
        Andriy Shevchenko <andriy.shevchenko@intel.com>,
        Mika Westerberg <mika.westerberg@intel.com>,
        Hock Leong Kweh <hock.leong.kweh@intel.com>,
        Darren Hart <dvhart@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 7:46 PM, Weike Chen <alvin.chen@intel.com> wrote:

> The Synopsys DesignWare APB GPIO driver only supports open firmware devices.
> But, like Intel Quark X1000 SOC, which has a single PCI function exporting
> a GPIO and an I2C controller, it is a Multifunction device. This patch is
> to enable the current Synopsys DesignWare APB GPIO driver to support the
> Multifunction device which exports the designware GPIO controller.
>
> Reviewed-by: Hock Leong Kweh <hock.leong.kweh@intel.com>
> Reviewed-by: Shevchenko, Andriy <andriy.shevchenko@intel.com>
> Signed-off-by: Weike Chen <alvin.chen@intel.com>

Sebastian, Jamie: can either of you take a look at this patch?

Yours,
Linus Walleij
