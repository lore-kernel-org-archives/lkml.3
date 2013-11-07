Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab3KGRQC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 12:16:02 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:61513 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab3KGRP7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 12:15:59 -0500
MIME-Version: 1.0
In-Reply-To: <1383748818-22487-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1383748818-22487-1-git-send-email-ricardo.ribalda@gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 7 Nov 2013 22:45:38 +0530
Message-ID: <CA+V-a8t6GDkmutbc0cL0Xqi4iwr-29sg9c09vsXqafeBNjA4mw@mail.gmail.com>
Subject: Re: [PATCH v2] ths7303: Declare as static a private function
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        "open list:MEDIA INPUT INFRA..." <linux-media@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ricardo,

Thanks for the patch.

On Wed, Nov 6, 2013 at 8:10 PM, Ricardo Ribalda Delgado
<ricardo.ribalda@gmail.com> wrote:
> git grep shows that the function is only called from ths7303.c
>
> Fix this build warning:
>
> CC      drivers/media/i2c/ths7303.o
> drivers/media/i2c/ths7303.c:86:5: warning: no previous prototype for  ‘ths7303_setval’ [-Wmissing-prototypes]
>    int ths7303_setval(struct v4l2_subdev *sd, enum ths7303_filter_mode mode)
>         ^
>
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad
