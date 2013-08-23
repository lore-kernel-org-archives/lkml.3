Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147Ab3HWSGF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 14:06:05 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:40821 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755765Ab3HWSGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 14:06:02 -0400
MIME-Version: 1.0
In-Reply-To: <20130822132207.GA27167@localhost>
References: <1377175611-4241-1-git-send-email-jszhang@marvell.com>
	<1377175611-4241-5-git-send-email-jszhang@marvell.com>
	<20130822132207.GA27167@localhost>
Date: Fri, 23 Aug 2013 20:06:02 +0200
Message-ID: <CACRpkdZKGUGnnwEt0W6hQKhA0NnHWtkeBuaz-chDS=9rZD9y7A@mail.gmail.com>
Subject: Re: [PATCH 4/4] pinctrl: mvebu: add missing iounmap
From: Linus Walleij <linus.walleij@linaro.org>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Jisheng Zhang <jszhang@marvell.com>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 3:22 PM, Ezequiel Garcia
<ezequiel.garcia@free-electrons.com> wrote:
> On Thu, Aug 22, 2013 at 08:46:51PM +0800, Jisheng Zhang wrote:
>> Add missing iounmap to prove error path and remove path
>>
>> Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
>> ---
>>  drivers/pinctrl/mvebu/pinctrl-mvebu.c | 24 +++++++++++++++++-------
>>  1 file changed, 17 insertions(+), 7 deletions(-)
>
> How about using devm_ioremap_resource() instead?

Yeah that's the right solution, Jisheng can you fix this?

Yours,
Linus Walleij
