Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab3F1CPH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 22:15:07 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:40199 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652Ab3F1CPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 22:15:05 -0400
MIME-Version: 1.0
In-Reply-To: <CADApbeiotgXqX2Y_w8C9zY3mf+MjJmsVS3VBKVdWxYHwNkV2SQ@mail.gmail.com>
References: <1369969115-4279-1-git-send-email-zhangwm@marvell.com>
	<2766142.mFu63TyH69@wuerfel>
	<CADApbejV3v11jedq=q9Nz7wyVWVAJp-4vYmAifsPb7UsdVj5zg@mail.gmail.com>
	<201306172334.05626.arnd@arndb.de>
	<CADApbeiotgXqX2Y_w8C9zY3mf+MjJmsVS3VBKVdWxYHwNkV2SQ@mail.gmail.com>
Date: Fri, 28 Jun 2013 10:15:04 +0800
Message-ID: <CADApbej-MejYuw5JpTYppZ7e0ce=OQoiJZ2pUWFY163SiXCGgg@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: mmp: bring up pxa988 with device tree support
From: Chao Xie <xiechao.mail@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Neil Zhang <zhangwm@marvell.com>, Chao Xie <cxie4@marvell.com>,
        "haojian.zhuang@gmail.com" <haojian.zhuang@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi, Arnd
SCU registers mapping can not be added to fixmap.
As Russell's suggested, the SCU registers can be mapped to 0xffff1000
with single page.
Beause the mapping is not a fix map, and i can not use the static
functions in arch/arm/mm/mm.h, I still have to use static mapping for
SCU registers by iotable_init.
So what is your idea about how to make the SCU registers mapping to be
a peice of common code?
Thanks.
