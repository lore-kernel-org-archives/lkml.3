Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751236AbaDSGmI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 02:42:08 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:51470 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbaDSGmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 02:42:00 -0400
MIME-Version: 1.0
In-Reply-To: <1397876987-11254-1-git-send-email-jinqiangzeng@gmail.com>
References: <1397876987-11254-1-git-send-email-jinqiangzeng@gmail.com>
From: Jianyu Zhan <nasa4836@gmail.com>
Date: Sat, 19 Apr 2014 14:41:19 +0800
Message-ID: <CAHz2CGVVf6tFsPRX90PZDHrWMoEd2Jn+2x3Rex-b2J0+2CZOSA@mail.gmail.com>
Subject: Re: [PATCH] fix the code style errors in sn9c102
To: Jinqiang Zeng <jinqiangzeng@gmail.com>
Cc: Luca Risolia <luca.risolia@studio.unibo.it>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 19, 2014 at 11:09 AM, Jinqiang Zeng <jinqiangzeng@gmail.com> wrote:
> ---
>  drivers/staging/media/sn9c102/sn9c102.h            |   30 +-
>  drivers/staging/media/sn9c102/sn9c102_core.c       |  342 ++++++++++----------
>  drivers/staging/media/sn9c102/sn9c102_devtable.h   |   22 +-
>  drivers/staging/media/sn9c102/sn9c102_hv7131d.c    |   22 +-
>  drivers/staging/media/sn9c102/sn9c102_hv7131r.c    |   22 +-
>  drivers/staging/media/sn9c102/sn9c102_mi0343.c     |   30 +-
>  drivers/staging/media/sn9c102/sn9c102_mi0360.c     |   30 +-
>  drivers/staging/media/sn9c102/sn9c102_ov7630.c     |   22 +-
>  drivers/staging/media/sn9c102/sn9c102_ov7660.c     |   22 +-
>  drivers/staging/media/sn9c1

Hi, Jinqiang,

you just missed something.
1. a "Signed-off-by" line, if you use git, git-format-patch is a good tool.;-)
2. better add a module name in cover later, like this:
     "sn9c102: fix the coding style errors"
3. maybe some changelog is good, but for this patch, leaving it out is OK.

You would better read the "Documentation/SubmittingPatches" .

Thanks,
Jianyu Zhan
