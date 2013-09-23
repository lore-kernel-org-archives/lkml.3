Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983Ab3IWTUl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 15:20:41 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:64496 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab3IWTUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 15:20:38 -0400
MIME-Version: 1.0
In-Reply-To: <5237782B.3030804@gmail.com>
References: <1379320326-13241-1-git-send-email-treding@nvidia.com>
	<1379320326-13241-6-git-send-email-treding@nvidia.com>
	<5237782B.3030804@gmail.com>
Date: Mon, 23 Sep 2013 21:20:37 +0200
Message-ID: <CACRpkdadFct8iXSaRRQ3a2YQryfMjJwVaq+8wgWXS1Ymj3M_WA@mail.gmail.com>
Subject: Re: [PATCH 5/9] of/irq: Introduce __of_irq_to_resource()
From: Linus Walleij <linus.walleij@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 11:29 PM, Rob Herring <robherring2@gmail.com> wrote:
> On 09/16/2013 03:32 AM, Thierry Reding wrote:
>> This is a version of of_irq_to_resource() that propagates the precise
>> error code instead of returning 0 for all errors. It will be used in
>> subsequent patches to allow further propagation of error codes.
>>
>> To avoid code duplication, implement of_irq_to_resource() as a wrapper
>> around the new __of_irq_to_resource().
>
> I think the callers in this case are manageable to update as well.
> Several cases could simply use irq_of_parse_and_map instead as they just
> pass in a NULL resource.

I second this comment.

Yours,
Linus Walleij
