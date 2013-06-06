Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932825Ab3FFKHl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 06:07:41 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42415 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932529Ab3FFKHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 06:07:36 -0400
Message-ID: <51B05F57.1070107@ti.com>
Date: Thu, 6 Jun 2013 15:37:19 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] ARM: davinci: dm365 evm: remove init_enable from
 ths7303 pdata
References: <1369503576-22271-1-git-send-email-prabhakar.csengg@gmail.com> <1369503576-22271-2-git-send-email-prabhakar.csengg@gmail.com> <51B011C5.3070105@ti.com> <CA+V-a8sz_Yz0oUB4s==uob4HxkW_6ShtsTx+Jut2LopmeErC1w@mail.gmail.com>
In-Reply-To: <CA+V-a8sz_Yz0oUB4s==uob4HxkW_6ShtsTx+Jut2LopmeErC1w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/6/2013 3:32 PM, Prabhakar Lad wrote:
> Hi Sekhar,
> 
> On Thu, Jun 6, 2013 at 10:06 AM, Sekhar Nori <nsekhar@ti.com> wrote:
>> On 5/25/2013 11:09 PM, Prabhakar Lad wrote:
>>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>>
>>> remove init_enable from ths7303 pdata as it is being dropped
>>> from ths7303_platform_data.
>>>
>>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>> Cc: Sekhar Nori <nsekhar@ti.com>
>>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
>>> Cc: linux-kernel@vger.kernel.org
>>> Cc: davinci-linux-open-source@linux.davincidsp.com
>>
>> Acked-by: Sekhar Nori <nsekhar@ti.com>
>>
> Thanks for the ack.
> 
>> I would prefer this be squashed into 2/4 but I leave it to you.
>>
> I would like to go as is :)

If you go this path, then may be repeat some of the explanation of why
init_enable is not needed from 2/4 here as well. Without that the
description above makes little sense.

Thanks,
Sekhar
