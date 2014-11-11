Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbaKKEn5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 23:43:57 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:48599 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbaKKEnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 23:43:55 -0500
Message-ID: <546193CF.8090107@ti.com>
Date: Tue, 11 Nov 2014 10:12:55 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        linux-api <linux-api@vger.kernel.org>,
        OSUOSL Drivers <devel@driverdev.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>, LDOC <linux-doc@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v3 06/10] [media] platform: Make use of media_bus_format
 enum
References: <1415369269-5064-1-git-send-email-boris.brezillon@free-electrons.com> <1415369269-5064-7-git-send-email-boris.brezillon@free-electrons.com> <CA+V-a8t79gYYGcgg5wvM-eqW8H2D6WD7xM9t2Px=WHb2rf34ow@mail.gmail.com>
In-Reply-To: <CA+V-a8t79gYYGcgg5wvM-eqW8H2D6WD7xM9t2Px=WHb2rf34ow@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 08 November 2014 02:48 PM, Prabhakar Lad wrote:
> Hi,
> 
> Thanks for the patch,
> 
> On Fri, Nov 7, 2014 at 2:07 PM, Boris Brezillon
> <boris.brezillon@free-electrons.com> wrote:
>> In order to have subsytem agnostic media bus format definitions we've
>> moved media bus definition to include/uapi/linux/media-bus-format.h and
>> prefixed values with MEDIA_BUS_FMT instead of V4L2_MBUS_FMT.
>>
>> Reference new definitions in all platform drivers.
>>
>> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
>> ---
>>  arch/arm/mach-davinci/board-dm355-evm.c            |   2 +-
>>  arch/arm/mach-davinci/board-dm365-evm.c            |   4 +-
>>  arch/arm/mach-davinci/dm355.c                      |   7 +-
>>  arch/arm/mach-davinci/dm365.c                      |   7 +-
> 
> @Sekhar can you ack for the machine changes for davinci ?

Heh, I don't have 6/10 in my inbox but have rest of the series. Can you
forward 6/10 to me?

Thanks,
Sekhar

