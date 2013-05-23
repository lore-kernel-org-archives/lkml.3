Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013Ab3EWJkY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 05:40:24 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:39030 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757913Ab3EWJkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 05:40:22 -0400
MIME-Version: 1.0
In-Reply-To: <201305231138.12523.hverkuil@xs4all.nl>
References: <1368709102-2854-1-git-send-email-prabhakar.csengg@gmail.com> <201305231138.12523.hverkuil@xs4all.nl>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 23 May 2013 15:10:02 +0530
Message-ID: <CA+V-a8vTnLi6=4QHmFArphQQh+a=eQaiJuSNd9EPFZzu2bpO=g@mail.gmail.com>
Subject: Re: [PATCH 0/7] media: davinci: vpif trivial cleanup
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LMML <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

On Thu, May 23, 2013 at 3:08 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Thu 16 May 2013 14:58:15 Lad Prabhakar wrote:
>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>
>> This patch series cleans the VPIF driver, uses devm_* api wherever
>> required and uses module_platform_driver() to simplify the code.
>>
>> This patch series applies on 3.10.rc1 and is tested on OMAP-L138.
>
> Can you repost this taken into account Laurent's comments regarding the
> unwanted header includes?
>
Yes I plan to do this weekend.

Regards,
--Prabhakar Lad
