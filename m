Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932760Ab3FFKGC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 06:06:02 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:39222 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079Ab3FFKF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 06:05:59 -0400
MIME-Version: 1.0
In-Reply-To: <2855590.yx9zfYZLis@avalon>
References: <1369503576-22271-1-git-send-email-prabhakar.csengg@gmail.com> <2855590.yx9zfYZLis@avalon>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 6 Jun 2013 15:35:38 +0530
Message-ID: <CA+V-a8vh-ttz1QQmV59fP5c3vK=1zC5QfmkHc9Du0ZAcY712Dg@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] media: i2c: ths7303 cleanup
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

On Sun, May 26, 2013 at 6:50 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> On Saturday 25 May 2013 23:09:32 Prabhakar Lad wrote:
>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>
>> Trivial cleanup of the driver.
>>
>> Changes for v2:
>> 1: Dropped the asynchronous probing and, OF
>>    support patches will be handling them independently because of
>> dependencies. 2: Arranged the patches logically so that git bisect
>>    succeeds.
>>
>> Lad, Prabhakar (4):
>>   ARM: davinci: dm365 evm: remove init_enable from ths7303 pdata
>>   media: i2c: ths7303: remove init_enable option from pdata
>>   media: i2c: ths7303: remove unnecessary function ths7303_setup()
>>   media: i2c: ths7303: make the pdata as a constant pointer
>>
Can you pick up this series or do you want me to issue a pull for it ?

Regards,
--Prabhakar Lad
