Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab3EaInZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 04:43:25 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:57102 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082Ab3EaInW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 04:43:22 -0400
MIME-Version: 1.0
In-Reply-To: <CA+V-a8sAXXq=gBO_uDsOS1MonXJan+mpBwo15tvp+wR40kAMKA@mail.gmail.com>
References: <1369503576-22271-1-git-send-email-prabhakar.csengg@gmail.com>
 <1369503576-22271-2-git-send-email-prabhakar.csengg@gmail.com> <CA+V-a8sAXXq=gBO_uDsOS1MonXJan+mpBwo15tvp+wR40kAMKA@mail.gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 31 May 2013 14:13:00 +0530
Message-ID: <CA+V-a8t8vx2S0rAZrZysF9PT2zVwx+EM0B5D=t50qoSiW8U_GA@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] ARM: davinci: dm365 evm: remove init_enable from
 ths7303 pdata
To: Sekhar Nori <nsekhar@ti.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-media <linux-media@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sekhar,

On Sat, May 25, 2013 at 11:13 PM, Prabhakar Lad
<prabhakar.csengg@gmail.com> wrote:
> Hi Sekhar,
>
> On Sat, May 25, 2013 at 11:09 PM, Prabhakar Lad
> <prabhakar.csengg@gmail.com> wrote:
>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>
>> remove init_enable from ths7303 pdata as it is being dropped
>> from ths7303_platform_data.
>>
> Can you please ack this patch as I intend to take this patch via media
> tree.
gentle ping.

Regards,
--Prabhakar
