Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933360AbaJVVsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 17:48:45 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:39423 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932605AbaJVVso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 17:48:44 -0400
MIME-Version: 1.0
In-Reply-To: <5447946B.9020007@xs4all.nl>
References: <1413146445-7304-1-git-send-email-prabhakar.csengg@gmail.com>
 <1413146445-7304-11-git-send-email-prabhakar.csengg@gmail.com> <5447946B.9020007@xs4all.nl>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 22 Oct 2014 22:48:12 +0100
Message-ID: <CA+V-a8tazN0u9kH085KyBZ3d3mc50kefAntkcuA84+yZtLK61A@mail.gmail.com>
Subject: Re: [PATCH 10/15] media: davinci: vpbe: add support for VIDIOC_CREATE_BUFS
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

On Wed, Oct 22, 2014 at 12:26 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Prabhakar,
>
> This patch series looks good, except for this one.
>
> If you add create_bufs support, then you should also update queue_setup.
>
> If the fmt argument to queue_setup is non-NULL, then check that the
> fmt.pix.sizeimage field is >= the current format's sizeimage. If not,
> return -EINVAL.
>
> This prevents userspace from creating additional buffers that are smaller
> than
> the minimum required size.
>
> I'm just skipping this patch and queuing all the others for 3.19. Just post
> an
> updated version for this one and I'll pick it up later.
>
I fixed it and posted the patch. To avoid conflicts I have rebased the patch on
for-v3.19a branch of your tree.

Thanks,
--Prabhakar Lad
