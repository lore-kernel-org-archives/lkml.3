Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259AbaIWMKv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 08:10:51 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:64288 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925AbaIWMKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 08:10:49 -0400
MIME-Version: 1.0
In-Reply-To: <1410970722-8579-3-git-send-email-alvin.chen@intel.com>
References: <1410970722-8579-1-git-send-email-alvin.chen@intel.com>
	<1410970722-8579-3-git-send-email-alvin.chen@intel.com>
Date: Tue, 23 Sep 2014 14:10:48 +0200
Message-ID: <CACRpkdYuDux776OtQGMtN7HvW-LNahV42Ltwa6PzgA1oApig3g@mail.gmail.com>
Subject: Re: [PATCH 2/4 v5] GPIO: gpio-dwapb: Change readl&writel to dwapb_read&dwapb_write
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

> This patch replaces 'readl&writel' with 'dwapb_read&dwapb_write'.
>
> Reviewed-by: Shevchenko, Andriy <andriy.shevchenko@intel.com>
> Signed-off-by: Weike Chen <alvin.chen@intel.com>

Patch applied.

Yours,
Linus Walleij
