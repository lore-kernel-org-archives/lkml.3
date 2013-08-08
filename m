Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965037Ab3HHKZH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 06:25:07 -0400
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4914 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965013Ab3HHKZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 06:25:04 -0400
Message-ID: <520371E3.2010802@xs4all.nl>
Date: Thu, 08 Aug 2013 12:24:35 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130630 Icedove/17.0.7
MIME-Version: 1.0
To: =?UTF-8?B?Sm9uIEFybmUgSsO4cmdlbnNlbg==?= <jonarne@jonarne.no>
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        m.chehab@samsung.com, hans.verkuil@cisco.com,
        prabhakar.csengg@gmail.com, laurent.pinchart@ideasonboard.com,
        andriy.shevchenko@linux.intel.com, ezequiel.garcia@free-electrons.com,
        timo.teras@iki.fi
Subject: Re: [RFC v4 0/3] saa7115: Implement i2c_board_info.platform_data
References: <1375535977-28913-1-git-send-email-jonarne@jonarne.no>
In-Reply-To: <1375535977-28913-1-git-send-email-jonarne@jonarne.no>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2013 03:19 PM, Jon Arne Jørgensen wrote:
> This patch set adds handling of the i2c_board_info struct to the saa7115 driver.
> The main goal of this patch is to give the different devices with the gm7113c
> chip an opportunity to configure the chip to their needs.
> 
> I've only implemented the overrides I know are necessary to get the stk1160
> and the smi2021 drivers to work.
> 
> This is the forth version of this patch series.
> There are only minor changes since version 3 of this patch series.
> I've mostly just changed some comments, and removed some debug statements
> in the last patch in the series.
> 
> The third version of the RFC was posted on 2013/7/4 and can be found here:
> http://lkml.indiana.edu/hypermail/linux/kernel/1307.0/01931.html
> 
> The second version of the RFC was posted on 2013/5/31 and can be found here:
> http://lkml.indiana.edu/hypermail/linux/kernel/1305.3/03747.html
> 
> The first version of the RFC can be found here:
> https://lkml.org/lkml/2013/5/29/558
> 
> Jon Arne Jørgensen (3):
>   saa7115: Fix saa711x_set_v4lstd for gm7113c
>   saa7115: Do not load saa7115_init_misc for gm7113c
>   saa7115: Implement i2c_board_info.platform_data
> 
>  drivers/media/i2c/saa7115.c      | 167 +++++++++++++++++++++++++++++++--------
>  drivers/media/i2c/saa711x_regs.h |  19 +++++
>  include/media/saa7115.h          |  64 +++++++++++++++
>  3 files changed, 216 insertions(+), 34 deletions(-)
> 

For this patch series:

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

I'll merge this Monday at the latest.

	Hans
