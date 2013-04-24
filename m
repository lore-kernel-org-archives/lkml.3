Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588Ab3DXJjp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 05:39:45 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:51795 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758548Ab3DXJjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 05:39:40 -0400
MIME-Version: 1.0
In-Reply-To: <20130423144256.GP5019@opensource.wolfsonmicro.com>
References: <1366614565-3743-1-git-send-email-ks.giri@samsung.com>
	<1366614565-3743-3-git-send-email-ks.giri@samsung.com>
	<20130423144256.GP5019@opensource.wolfsonmicro.com>
Date: Wed, 24 Apr 2013 15:09:38 +0530
Message-ID: <CAKrE-KdJZHzVH-0sRkP2hyPBcn9CMiqgQBcrZTap6zwVuAhZLQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] spi: s3c64xx: Added provision for dedicated cs pin
From: Girish KS <girishks2000@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        t.figa@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 8:12 PM, Mark Brown <broonie@kernel.org> wrote:
> On Mon, Apr 22, 2013 at 12:39:24PM +0530, Girish K S wrote:
>> From: Girish K S <girishks2000@gmail.com>
>>
>> The existing driver supports gpio based /cs signal.
>> For controller's that have one device per controller,
>> the slave device's /cs signal might be internally controlled
>> by the chip select bit of slave select register. They are not
>> externally asserted/deasserted using gpio pin.
>
> This doesn't build:
>
> drivers/spi/spi-s3c64xx.c: In function 's3c64xx_get_slave_ctrldata':
> drivers/spi/spi-s3c64xx.c:1023: error: 'sdd' undeclared (first use in this function)
> drivers/spi/spi-s3c64xx.c:1023: error: (Each undeclared identifier is reported only once
> drivers/spi/spi-s3c64xx.c:1023: error: for each function it appears in.)

Ohhhhhh. Sorry. forgot to commit the changes before patch generation
