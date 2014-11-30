Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326AbaK3VGZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 16:06:25 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:57206 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbaK3VGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 16:06:23 -0500
MIME-Version: 1.0
In-Reply-To: <3017627.SLutb67dz2@avalon>
References: <1416220913-5047-1-git-send-email-prabhakar.csengg@gmail.com>
 <20141118180759.GT8907@valkosipuli.retiisi.org.uk> <CA+V-a8s-mP+Fjok2s_nDUAOb4vN3RWyRc5VHuZqPdk4pJtv03A@mail.gmail.com>
 <3017627.SLutb67dz2@avalon>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Sun, 30 Nov 2014 21:05:50 +0000
Message-ID: <CA+V-a8tNW8JXKEeaAwEKkB+SCS2_My228spsgpbb5JQPjdC2Og@mail.gmail.com>
Subject: Re: [PATCH] media: v4l2-subdev.h: drop the guard CONFIG_VIDEO_V4L2_SUBDEV_API
 for v4l2_subdev_get_try_*()
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        linux-media <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Sat, Nov 29, 2014 at 7:12 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Prabhakar,
>
[Snip]
>> > Sure. That's a better choice than removing the config option dependency of
>> > the fields struct v4l2_subdev.
>
> Decoupling CONFIG_VIDEO_V4L2_SUBDEV_API from the availability of the in-kernel
> pad format and selection rectangles helpers is definitely a good idea. I was
> thinking about decoupling the try format and rectangles from v4l2_subdev_fh by
> creating a kind of configuration store structure to store them, and embedding
> that structure in v4l2_subdev_fh. The pad-level operations would then take a
> pointer to the configuration store instead of the v4l2_subdev_fh. Bridge
> drivers that want to implement TRY_FMT based on pad-level operations would
> create a configuration store, use the pad-level operations, and destroy the
> configuration store. The userspace subdev API would use the configuration
> store from the file handle.
>
are planning to work/post any time soon ? Or are you OK with suggestion from
Hans ?

Thanks,
--Prabhakar Lad
