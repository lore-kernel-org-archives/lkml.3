Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226AbaG1KWq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 06:22:46 -0400
Received: from mail-oi0-f47.google.com ([209.85.218.47]:62821 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbaG1KWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 06:22:45 -0400
MIME-Version: 1.0
In-Reply-To: <1406271288-15995-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1406271288-15995-1-git-send-email-mika.westerberg@linux.intel.com>
Date: Mon, 28 Jul 2014 12:22:44 +0200
Message-ID: <CACRpkdakZcDMRPzgemu8r93EdaQU+rO1SovzBHNYAq_1=p5n4Q@mail.gmail.com>
Subject: Re: [PATCH 0/3] gpio: Convert two Intel GPIO drivers to use irqchip helpers
From: Linus Walleij <linus.walleij@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Zhu Lejun <lejun.zhu@linux.intel.com>, Yang Bin <bin.yang@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 8:54 AM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:

> This series converts the Intel Lynxpoint and Baytrail GPIO drivers to use
> the new irqchip helper functions and then moves ACPI event registration to
> happen in the helpers as well.

Excellent patch set and irresistable to merge.

Applied patches 1 & 3 to the GPIO tree and patch 2 to the pinctrl tree.

Yours,
Linus Walleij
