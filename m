Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab3IWTS6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 15:18:58 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:50436 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab3IWTS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 15:18:56 -0400
MIME-Version: 1.0
In-Reply-To: <20130917132834.GC6757@ulmo>
References: <1379320326-13241-1-git-send-email-treding@nvidia.com>
	<1379320326-13241-5-git-send-email-treding@nvidia.com>
	<5237771F.1060908@gmail.com>
	<20130917132834.GC6757@ulmo>
Date: Mon, 23 Sep 2013 21:18:52 +0200
Message-ID: <CACRpkdYQxD_GAeym7D=npBfrmn88MRYOFh9i2V0xeByiEiWKGQ@mail.gmail.com>
Subject: Re: [PATCH 4/9] of/irq: Introduce of_irq_get()
From: Linus Walleij <linus.walleij@linaro.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Rob Herring <robherring2@gmail.com>,
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

On Tue, Sep 17, 2013 at 3:28 PM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> On Mon, Sep 16, 2013 at 04:24:47PM -0500, Rob Herring wrote:

>> *_get typically also implies some reference counting which I don't
>> believe this does. I don't think having 2 functions with completely
>> different names doing the same thing with only a different calling
>> convention is good either. So I would keep the old name and the names
>> aligned.
>
> Okay, I'll make the new function __irq_of_parse_and_map().

I don't know why i detest __prefixing so much but I think it's
really nasty.

Usually this is reserved for compiler- and linker related things,
like __packed;  or __init.

I would prefer irq_of_parse_and_map_strict() or something
like that.

Yours,
Linus Walleij
