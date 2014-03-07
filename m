Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbaCGDs1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 22:48:27 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:36994 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaCGDsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 22:48:25 -0500
MIME-Version: 1.0
In-Reply-To: <20140306201803.GL1872@titan.lakedaemon.net>
References: <1393977790-29110-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1393977790-29110-4-git-send-email-sebastian.hesselbarth@gmail.com>
	<20140306201803.GL1872@titan.lakedaemon.net>
Date: Fri, 7 Mar 2014 11:48:25 +0800
Message-ID: <CACRpkda0JCLZUv_KPmwucDh3ko2YbtG2ukMMscSodAbBpiY+zw@mail.gmail.com>
Subject: Re: [PATCH 3/3] pinctrl: mvebu: silence WARN to dev_warn
From: Linus Walleij <linus.walleij@linaro.org>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 7, 2014 at 4:18 AM, Jason Cooper <jason@lakedaemon.net> wrote:
> On Wed, Mar 05, 2014 at 01:03:10AM +0100, Sebastian Hesselbarth wrote:
>> Pinctrl will WARN on missing DT resources, which is a little bit too
>> noisy. Use dev_warn with FW_BUG instead.
>>
>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>> ---
>> Cc: Russell King <linux@arm.linux.org.uk>
>> Cc: Jason Cooper <jason@lakedaemon.net>
>> Cc: Andrew Lunn <andrew@lunn.ch>
>> Cc: Gregory Clement <gregory.clement@free-electrons.com>
>> Cc: Linus Walleij <linus.walleij@linaro.org>
>> Cc: devicetree@vger.kernel.org
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
>>  drivers/pinctrl/mvebu/pinctrl-dove.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> Applied to mvebu/pinctrl

So are you carrying this patch, or shall I apply it to my tree?

In the former case: Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
