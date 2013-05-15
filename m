Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758779Ab3EOMMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 08:12:14 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:59659 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356Ab3EOMMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 08:12:13 -0400
MIME-Version: 1.0
In-Reply-To: <1928313.pnnBGKgv0p@avalon>
References: <1368619042-28252-1-git-send-email-prabhakar.csengg@gmail.com>
 <1368619042-28252-3-git-send-email-prabhakar.csengg@gmail.com> <1928313.pnnBGKgv0p@avalon>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 15 May 2013 17:41:51 +0530
Message-ID: <CA+V-a8uU6QkYcMg1b5BPHbA0gUGypZeXZNScE-WLa-GqK4_fQA@mail.gmail.com>
Subject: Re: [PATCH 2/6] ARM: davinci: dm365 evm: remove init_enable from
 ths7303 pdata
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Sekhar Nori <nsekhar@ti.com>, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

Thanks for the review.

On Wed, May 15, 2013 at 5:35 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Prabhakar,
>
> Thank you for the patch.
>
> On Wednesday 15 May 2013 17:27:18 Lad Prabhakar wrote:
>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>
>> remove init_enable from ths7303 pdata as it is no longer exists.
>
> You should move this before 1/6, otherwise you will break bisection.
>
OK I'll fix it in next version.

Regards,
--Prabhakar Lad
