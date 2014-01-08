Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbaAHKPn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 05:15:43 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:37344 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755224AbaAHKPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 05:15:37 -0500
MIME-Version: 1.0
In-Reply-To: <20131108111152.GL2493@sirena.org.uk>
References: <1383816846-10561-1-git-send-email-richard.genoud@gmail.com> <20131108111152.GL2493@sirena.org.uk>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Wed, 8 Jan 2014 11:15:13 +0100
Message-ID: <CACQ1gAhsKeQUB_vN9iJDbBsJ+7CiOZH8O=ZPg96pP8qRDHf15g@mail.gmail.com>
Subject: Re: [PATCH] spi: atmel: add support for changing message transfer speed
To: Mark Brown <broonie@kernel.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Wenyou Yang <Wenyou.Yang@atmel.com>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/11/8 Mark Brown <broonie@kernel.org>:
> On Thu, Nov 07, 2013 at 10:34:06AM +0100, Richard Genoud wrote:
>> The only speed available was max_speed (the maximum speed declared for a
>> device).
>> This patch adds the support for spi_tranfer->speed_hz parameter.
>> We can now set a different speed for each spi message.
>
> Applied, thanks.

It seems that this patch got lost (or I missed something).
As it will now conflict with Wenyou patch "Refactor spi-atmel to use
SPI framework queue",
should I resent it based on wenyou's path ?
or on broonie/spi.git for-next and wenyou will rebase his patch on mine ?
