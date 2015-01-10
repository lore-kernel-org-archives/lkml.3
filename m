Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbbAJVqx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 16:46:53 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:37149 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbbAJVqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 16:46:52 -0500
MIME-Version: 1.0
In-Reply-To: <1420798956.23114.18.camel@mtksdaap41>
References: <1420796506-10402-1-git-send-email-linus.walleij@linaro.org>
	<1420798956.23114.18.camel@mtksdaap41>
Date: Sat, 10 Jan 2015 22:46:51 +0100
Message-ID: <CACRpkdYO2qhCjP2inviaAji-T-kLYxBUO0WxC_69Y96n2cp-Mg@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: pass -DDEBUG in subdirs
From: Linus Walleij <linus.walleij@linaro.org>
To: Yingjoe Chen <yingjoe.chen@mediatek.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 9, 2015 at 11:22 AM, Yingjoe Chen <yingjoe.chen@mediatek.com> wrote:
>
> On Fri, 2015-01-09 at 10:41 +0100, Linus Walleij wrote:
>> When drivers are compiled in subdirectories the -DDEBUG flag need
>> to be passed in the individual Makefiles.
>
> Hi,
>
> It will be easy to forget adding this when adding new subdirectories.
> Can we do this instead?
(...)
> -ccflags-$(CONFIG_DEBUG_PINCTRL)        += -DDEBUG
> +subdir-ccflags-$(CONFIG_DEBUG_PINCTRL) += -DDEBUG

Yeah of course :/

subdir-ccflags applies to this subdir and all below it then I take it.
Typical I don't know such stuff :(

Yours,
Linus Walleij
