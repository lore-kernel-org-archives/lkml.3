Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758043Ab3EWJmC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 05:42:02 -0400
Received: from mail-vb0-f51.google.com ([209.85.212.51]:58789 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757881Ab3EWJl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 05:41:57 -0400
MIME-Version: 1.0
In-Reply-To: <201305231135.37204.hverkuil@xs4all.nl>
References: <1368528334-13595-1-git-send-email-prabhakar.csengg@gmail.com>
 <1368528334-13595-4-git-send-email-prabhakar.csengg@gmail.com> <201305231135.37204.hverkuil@xs4all.nl>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 23 May 2013 15:11:36 +0530
Message-ID: <CA+V-a8vyg_OjWkvsuEdi_-NZRLkA3ZSEWnM_vox9KG+vK=k6Dw@mail.gmail.com>
Subject: Re: [PATCH 3/5] media: i2c: tvp7002: rearrange header inclusion alphabetically
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

On Thu, May 23, 2013 at 3:05 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Tue 14 May 2013 12:45:32 Lad Prabhakar wrote:
>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>
>> This patch rearranges the header inclusion alphabetically
>> and also removes unnecessary includes.
>
> As Laurent mentioned in a review for another patch (vpif) you probably
> shouldn't remove these headers. videodev2.h is certainly used, as is slab.h
> and v4l2-common.h. In the past removing slab.h causes problems on other
> architectures where that header isn't automatically included by other
> headers.
>
OK

> I would just drop this patch. I've merged the first two patches of
> this patch series, the last two I can't merge as long as the async
> code isn't in yet.
>
Thanks. yes the last two depend on v4l-async patches.

Regards,
--Prabhakar Lad
