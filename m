Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444AbaDXN3O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 09:29:14 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:50791 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128AbaDXN3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 09:29:08 -0400
MIME-Version: 1.0
In-Reply-To: <20140424115848.GG30677@intel.com>
References: <534B93BA.6020406@linux.intel.com>
	<534BFAAF.3070805@codeaurora.org>
	<534D0370.50108@linux.intel.com>
	<535005BA.1040405@codeaurora.org>
	<5357A80B.8030701@linux.intel.com>
	<5357ACF1.9070206@codeaurora.org>
	<20140423135915.GY30677@intel.com>
	<5357D8CC.3080501@codeaurora.org>
	<20140424063546.GA30677@intel.com>
	<5358F30E.9080402@codeaurora.org>
	<20140424115848.GG30677@intel.com>
Date: Thu, 24 Apr 2014 15:29:07 +0200
Message-ID: <CACRpkdamMrQLKPGQey1FEXsA_e7Fh5VT3yrqx7ytXsM3aMX14w@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] pinctrl: add Intel BayTrail GPIO/pinctrl support
From: Linus Walleij <linus.walleij@linaro.org>
To: "Westerberg, Mika" <mika.westerberg@intel.com>
Cc: Timur Tabi <timur@codeaurora.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        lkml <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 1:58 PM, Westerberg, Mika
<mika.westerberg@intel.com> wrote:
> On Thu, Apr 24, 2014 at 06:18:38AM -0500, Timur Tabi wrote:

>> I'm wondering why a pinctrl driver for an
>> ACPI platform should be defining pinmux function groups.  I haven't
>> gotten a straight answer to that question.
>
> Are you asking why pinctrl-baytrail.c uses pinctrl_gpio_ranges even if it
> is a pretty much standard GPIO driver? Mathias probably can answer that
> question better than me.

That was done on my request since any other approach obviously
would lead to code duplication of exactly what GPIO ranges does.

Yours,
Linus Walleij
