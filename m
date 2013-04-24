Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139Ab3DXJ2H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 05:28:07 -0400
Received: from mail-ia0-f180.google.com ([209.85.210.180]:64746 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757866Ab3DXJ2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 05:28:05 -0400
MIME-Version: 1.0
In-Reply-To: <20130423183301.GX5019@opensource.wolfsonmicro.com>
References: <1364968581-23700-1-git-send-email-wenyou.yang@atmel.com>
 <1364968759-24036-1-git-send-email-wenyou.yang@atmel.com> <20130403102332.GA4633@lnx-rg>
 <20130423183301.GX5019@opensource.wolfsonmicro.com>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Wed, 24 Apr 2013 11:27:44 +0200
Message-ID: <CACQ1gAh8QyZReJF2nQLQYSrYLv0vCw_ZS5rLg+S39LbbMJQyxQ@mail.gmail.com>
Subject: Re: [PATCH v8 3/8] spi/spi-atmel: add dmaengine support
To: Mark Brown <broonie@kernel.org>
Cc: Wenyou Yang <wenyou.yang@atmel.com>, linux-arm-kernel@lists.infradead.org,
        grant.likely@secretlab.ca, plagnioj@jcrosoft.com,
        nicolas.ferre@atmel.com, JM.Lin@atmel.com,
        spi-devel-general@lists.sourceforge.net,
        spi-devel-general@lists.sourceforge.ne, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/23 Mark Brown <broonie@kernel.org>:
> On Wed, Apr 03, 2013 at 12:23:35PM +0200, Richard GENOUD wrote:
>
> Richard, delete irrelevant context from your mails - it makes it much
> easier to find the content you added.
>
>> On [mer., 03.04.2013 13:59:19], Wenyou Yang wrote:
>
>> As I did some work on that one:
>> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
>>
>> BUT, there's one thing not working (at least for me !):
>> With DMA enabled, using spidev.
>> if we use the ioctl SPI_IOC_MESSAGE(x) (tested with x=3):
>
> I'd been expecting an updated series with this rolled in?

I did some more test with spidev and a MISO-MOSI loop as Wenyou suggested.

It's ok for me, on kernel 3.9-rc8 sam9g35, I didn't see any error.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
Tested-by: Richard Genoud <richard.genoud@gmail.com>
