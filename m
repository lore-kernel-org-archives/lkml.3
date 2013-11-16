Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108Ab3KPQLT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 11:11:19 -0500
Received: from mail-ve0-f171.google.com ([209.85.128.171]:51545 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab3KPQLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 11:11:11 -0500
MIME-Version: 1.0
X-Originating-IP: [212.255.42.50]
In-Reply-To: <20131116160601.GA8723@katana>
References: <528791EF.9060505@koalo.de>
	<20131116160601.GA8723@katana>
Date: Sat, 16 Nov 2013 17:11:10 +0100
Message-ID: <CABDT8WzUoPmPzDnjD3w+Oj=jUVcMf91+toWDS+hK6CrXLveCFg@mail.gmail.com>
Subject: Re: [PATCH] i2c: Fallback to of_node of parent
From: Florian Meier <florian.meier@koalo.de>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, I will try to find all relevant lines.
Where is the best place to document this?

Greetings,
Florian

2013/11/16 Wolfram Sang <wsa@the-dreams.de>:
>
>> +     if (!dev->of_node && dev->parent)
>> +             dev->of_node = dev->parent->of_node;
>> +
>
> That is not enough. Current drivers could then have the assignment
> removed and even more important, this behaviour should be documented.
>
> Regards,
>
>    Wolfram
>
