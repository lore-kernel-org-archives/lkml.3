Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbaJ1KAF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 06:00:05 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:56239 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482AbaJ1KAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 06:00:03 -0400
MIME-Version: 1.0
In-Reply-To: <1413290117-13082-8-git-send-email-k.kozlowski@samsung.com>
References: <1413290117-13082-1-git-send-email-k.kozlowski@samsung.com>
	<1413290117-13082-8-git-send-email-k.kozlowski@samsung.com>
Date: Tue, 28 Oct 2014 11:00:01 +0100
Message-ID: <CACRpkdbtCU-c6EuYPN0oxUS2TWsrBSh6zQ2kO4FijzzE=asFmQ@mail.gmail.com>
Subject: Re: [PATCH 7/7] mfd: ab8500: Decrement the power supply's device
 reference counter
From: Linus Walleij <linus.walleij@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Lv Zheng <lv.zheng@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Anton Vorontsov <anton@enomsg.org>, Pavel Machek <pavel@ucw.cz>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 2:35 PM, Krzysztof Kozlowski
<k.kozlowski@samsung.com> wrote:

> Use power_supply_put() to decrement the power supply's device reference
> counter.
>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
