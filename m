Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932518Ab3FFKDL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 06:03:11 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:62163 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104Ab3FFKDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 06:03:09 -0400
MIME-Version: 1.0
In-Reply-To: <51B011C5.3070105@ti.com>
References: <1369503576-22271-1-git-send-email-prabhakar.csengg@gmail.com>
 <1369503576-22271-2-git-send-email-prabhakar.csengg@gmail.com> <51B011C5.3070105@ti.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 6 Jun 2013 15:32:46 +0530
Message-ID: <CA+V-a8sz_Yz0oUB4s==uob4HxkW_6ShtsTx+Jut2LopmeErC1w@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] ARM: davinci: dm365 evm: remove init_enable from
 ths7303 pdata
To: Sekhar Nori <nsekhar@ti.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sekhar,

On Thu, Jun 6, 2013 at 10:06 AM, Sekhar Nori <nsekhar@ti.com> wrote:
> On 5/25/2013 11:09 PM, Prabhakar Lad wrote:
>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>
>> remove init_enable from ths7303 pdata as it is being dropped
>> from ths7303_platform_data.
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> Cc: Sekhar Nori <nsekhar@ti.com>
>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
>> Cc: linux-kernel@vger.kernel.org
>> Cc: davinci-linux-open-source@linux.davincidsp.com
>
> Acked-by: Sekhar Nori <nsekhar@ti.com>
>
Thanks for the ack.

> I would prefer this be squashed into 2/4 but I leave it to you.
>
I would like to go as is :)

Regards,
--Prabhakar Lad
