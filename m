Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379Ab3H1MTV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 08:19:21 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:48637 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab3H1MTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 08:19:20 -0400
MIME-Version: 1.0
In-Reply-To: <20130827144253.GC19598@titan.lakedaemon.net>
References: <1377578476-3268-1-git-send-email-jszhang@marvell.com>
	<20130827144253.GC19598@titan.lakedaemon.net>
Date: Wed, 28 Aug 2013 14:19:19 +0200
Message-ID: <CACRpkdZD5mjf9KUJD3fSM7z7jp6UBabfjAUAUT=TDLGbbJLjow@mail.gmail.com>
Subject: Re: [PATCH v5 0/3] arm: mvebu: fix resource leak
From: Linus Walleij <linus.walleij@linaro.org>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Jisheng Zhang <jszhang@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 4:42 PM, Jason Cooper <jason@lakedaemon.net> wrote:
> On Tue, Aug 27, 2013 at 12:41:13PM +0800, Jisheng Zhang wrote:

>>   pinctrl: mvebu: Convert to use devm_ioremap_resource
>
> Previously Acked patch 3 for LinusW

I've taken that one into the pinctrl tree now.

Yours,
Linus Walleij
