Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbaIWMJb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 08:09:31 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:37291 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbaIWMJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 08:09:29 -0400
MIME-Version: 1.0
In-Reply-To: <1410970722-8579-2-git-send-email-alvin.chen@intel.com>
References: <1410970722-8579-1-git-send-email-alvin.chen@intel.com>
	<1410970722-8579-2-git-send-email-alvin.chen@intel.com>
Date: Tue, 23 Sep 2014 14:09:28 +0200
Message-ID: <CACRpkdaczdSkygXzbwcAudf3hPLbSwrZB7zLysHZrkTyx3g=Bw@mail.gmail.com>
Subject: Re: [PATCH 1/4 v5] GPIO: gpio-dwapb: Enable platform driver binding
 to MFD driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Weike Chen <alvin.chen@intel.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, atull <atull@opensource.altera.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Boon Leong Ong <boon.leong.ong@intel.com>,
        Hock Leong Kweh <hock.leong.kweh@intel.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Mika Westerberg <mika.westerberg@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 6:18 PM, Weike Chen <alvin.chen@intel.com> wrote:

> The Synopsys DesignWare APB GPIO driver only supports open firmware devices.
> But, like Intel Quark X1000 SOC, which has a single PCI function exporting
> a GPIO and an I2C controller, it is a Multifunction device. This patch is
> to enable the current Synopsys DesignWare APB GPIO driver to support the
> Multifunction device which exports the designware GPIO controller.
>
> Reviewed-by: Hock Leong Kweh <hock.leong.kweh@intel.com>
> Signed-off-by: Weike Chen <alvin.chen@intel.com>

OK no further comments, patch applied.

Yours,
Linus Walleij
