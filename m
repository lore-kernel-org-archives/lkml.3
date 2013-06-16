Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab3FPB6o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 21:58:44 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:48342 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849Ab3FPB6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 21:58:42 -0400
MIME-Version: 1.0
In-Reply-To: <2064603.dg6NN5EgtL@avalon>
References: <1371314050-25866-1-git-send-email-prabhakar.csengg@gmail.com> <2064603.dg6NN5EgtL@avalon>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Sun, 16 Jun 2013 07:28:21 +0530
Message-ID: <CA+V-a8vByuGkGaZSYwWTUSoQenbryTnDVayZK5F9SsS+Z_GGSQ@mail.gmail.com>
Subject: Re: [PATCH] media: i2c: ths7303: remove unused member driver_data
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Sun, Jun 16, 2013 at 5:21 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Prabhakar,
>
> Thanks for the patch.
>
> On Saturday 15 June 2013 22:04:10 Prabhakar Lad wrote:
>> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>>
>> This patch removes the driver_data member from ths7303_state structure.
>> The driver_data member was intended to differentiate between ths7303 and
>> ths7353 chip and get the g_chip_ident, But as of now g_chip_ident is
>> obsolete, so there is no need of driver_data.
>
> What tree it this based on ? linuxtv/master still uses driver_data in the
> ths7303_g_chip_ident() function.
>
Ah forgot to mention this is based on Hans's branch
http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/for-v3.11

Regards,
--Prabhakar Lad
