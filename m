Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbaCLOCU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 10:02:20 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:34431 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415AbaCLOCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 10:02:02 -0400
MIME-Version: 1.0
In-Reply-To: <20140307134616.GR1872@titan.lakedaemon.net>
References: <1393977790-29110-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1393977790-29110-4-git-send-email-sebastian.hesselbarth@gmail.com>
	<20140306201803.GL1872@titan.lakedaemon.net>
	<CACRpkda0JCLZUv_KPmwucDh3ko2YbtG2ukMMscSodAbBpiY+zw@mail.gmail.com>
	<20140307035056.GQ1872@titan.lakedaemon.net>
	<CACRpkdbEQSj7jLWT2BFR22m7phwmyKCByhQuFFgHvHoKvQFD5g@mail.gmail.com>
	<20140307134616.GR1872@titan.lakedaemon.net>
Date: Wed, 12 Mar 2014 15:02:02 +0100
Message-ID: <CACRpkdbcbMNim9LRkr75Mk5yHfwbA1OAexByHG50qDUPwts4uQ@mail.gmail.com>
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

On Fri, Mar 7, 2014 at 2:46 PM, Jason Cooper <jason@lakedaemon.net> wrote:
> On Fri, Mar 07, 2014 at 11:56:11AM +0800, Linus Walleij wrote:

>> For a single patch?
>
> Well, just the doc change and WARN change.  I've already taken the dts
> change into mvebu/dt (for arm-soc).

I've applied this patch [3/3] to the pinctrl tree.

> There should be no need for these two to be in mvebu's for-next, so if
> it's easier for you to pick them, please do so.
>
> I'll drop them from mvebu/pinctrl and update mvebu's for-next right now.

No, I mean, please apply patch 1/3 and 2/3 to the mvebu tree.
There is no need to sync DTS and pinctrl driver changes. This
patch to the pinctrl driver I want to carry however.

Yours,
Linus Walleij
