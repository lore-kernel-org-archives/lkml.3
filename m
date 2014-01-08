Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713AbaAHNGQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 08:06:16 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:59879 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756020AbaAHNGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 08:06:11 -0500
MIME-Version: 1.0
In-Reply-To: <20140108130154.GD31886@sirena.org.uk>
References: <1383816846-10561-1-git-send-email-richard.genoud@gmail.com>
 <20131108111152.GL2493@sirena.org.uk> <CACQ1gAhsKeQUB_vN9iJDbBsJ+7CiOZH8O=ZPg96pP8qRDHf15g@mail.gmail.com>
 <20140108130154.GD31886@sirena.org.uk>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Wed, 8 Jan 2014 14:05:49 +0100
Message-ID: <CACQ1gAicacBHyRf+tRCB4msmakvV-n1vksisHmXpYN+M1qGF7A@mail.gmail.com>
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

2014/1/8 Mark Brown <broonie@kernel.org>:
> On Wed, Jan 08, 2014 at 11:15:13AM +0100, Richard Genoud wrote:
>
>> It seems that this patch got lost (or I missed something).
>> As it will now conflict with Wenyou patch "Refactor spi-atmel to use
>> SPI framework queue",
>> should I resent it based on wenyou's path ?
>> or on broonie/spi.git for-next and wenyou will rebase his patch on mine ?
>
> It was applied but not pushed out, pushed it out now.
Ok, thanks !
