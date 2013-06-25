Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab3FYJRY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 05:17:24 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:57209 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab3FYJRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 05:17:21 -0400
MIME-Version: 1.0
In-Reply-To: <201306240951.07426.hverkuil@xs4all.nl>
References: <1371913383-25088-1-git-send-email-prabhakar.csengg@gmail.com> <201306240951.07426.hverkuil@xs4all.nl>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 25 Jun 2013 14:46:59 +0530
Message-ID: <CA+V-a8v7Lryu1VQ5Qygugr23FfNvrktz_CAm=ZPyrgEX63u1zw@mail.gmail.com>
Subject: Re: [PATCH RFC v3] media: OF: add video sync endpoint property
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

On Mon, Jun 24, 2013 at 1:21 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Prabhakar,
>
> On Sat June 22 2013 17:03:03 Prabhakar Lad wrote:
>> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>>
[snip]
>> +#ifndef _DT_BINDINGS_VIDEO_INTERFACES_H
>> +#define _DT_BINDINGS_VIDEO_INTERFACES_H
>> +
>> +#define V4L2_MBUS_VIDEO_SEPARATE_SYNC                (1 << 2)
>> +#define V4L2_MBUS_VIDEO_COMPOSITE_SYNC               (1 << 3)
>> +#define V4L2_MBUS_VIDEO_SYNC_ON_COMPOSITE    (1 << 4)
>
> What on earth is the difference between "COMPOSITE_SYNC" and "SYNC_ON_COMPOSITE"?!
>
This link http://en.wikipedia.org/wiki/Component_video_sync
would give a better explanation about it.

Regards,
--Prabhakar Lad
