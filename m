Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab3EPLs0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 07:48:26 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:38809 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527Ab3EPLsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 07:48:21 -0400
MIME-Version: 1.0
In-Reply-To: <CA+V-a8uU6QkYcMg1b5BPHbA0gUGypZeXZNScE-WLa-GqK4_fQA@mail.gmail.com>
References: <1368619042-28252-1-git-send-email-prabhakar.csengg@gmail.com>
 <1368619042-28252-3-git-send-email-prabhakar.csengg@gmail.com>
 <1928313.pnnBGKgv0p@avalon> <CA+V-a8uU6QkYcMg1b5BPHbA0gUGypZeXZNScE-WLa-GqK4_fQA@mail.gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 16 May 2013 17:18:00 +0530
Message-ID: <CA+V-a8txWU=ohuJfmtKk5fQ_rh_qsp8wA72vUXWEDBZU1TJR-g@mail.gmail.com>
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

On Wed, May 15, 2013 at 5:41 PM, Prabhakar Lad
<prabhakar.csengg@gmail.com> wrote:
> Hi Laurent,
>
> Thanks for the review.
>
> On Wed, May 15, 2013 at 5:35 PM, Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
>> Hi Prabhakar,
>>
>> Thank you for the patch.
>>
>> On Wednesday 15 May 2013 17:27:18 Lad Prabhakar wrote:
>>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>>
>>> remove init_enable from ths7303 pdata as it is no longer exists.
>>
>> You should move this before 1/6, otherwise you will break bisection.
>>
How about I just reshuffles while issuing a pull rather than resending
the whole series ?

Regards,
--Prabhakar Lad
