Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab3FXIQ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 04:16:26 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:53098 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064Ab3FXIQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 04:16:24 -0400
MIME-Version: 1.0
In-Reply-To: <201306240914.22490.hverkuil@xs4all.nl>
References: <1371923055-29623-1-git-send-email-prabhakar.csengg@gmail.com>
 <1371923055-29623-2-git-send-email-prabhakar.csengg@gmail.com> <201306240914.22490.hverkuil@xs4all.nl>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 24 Jun 2013 13:46:03 +0530
Message-ID: <CA+V-a8tMHZTNXr0NhsPAtwfBR+rKFRapOhqKqfOr5X0-jR=_6g@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] media: i2c: tvp7002: add support for asynchronous probing
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

On Mon, Jun 24, 2013 at 12:44 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Sat June 22 2013 19:44:14 Prabhakar Lad wrote:
>> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>>
>> Both synchronous and asynchronous tvp7002 subdevice probing
>> is supported by this patch.
>
> Can I merge this patch without patch 2/2? Or should I wait with both until
> the video sync properties have been approved?
>
You can go ahead and merge this one no need to wait for 2/2, I know
the video sync will take more time :)

Regards,
--Prabhakar Lad
