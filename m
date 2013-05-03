Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763115Ab3ECKQJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 06:16:09 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:32779 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761959Ab3ECKQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 06:16:07 -0400
MIME-Version: 1.0
In-Reply-To: <51838994.7070805@ti.com>
References: <1366804808-22720-1-git-send-email-prabhakar.csengg@gmail.com>
 <1780031.B4OAypccep@avalon> <CA+V-a8sLD2dP1RLb8ibZDOsLCP8hhMNUTr-zzU1zx_2ALDaDrg@mail.gmail.com>
 <51838994.7070805@ti.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 3 May 2013 15:45:44 +0530
Message-ID: <CA+V-a8tM=VxvCt5dvbLSJz-pz7OS88QaHJ9r_Y+ysxP_JUzn2Q@mail.gmail.com>
Subject: Re: [PATCH 0/6] Davinci fbdev driver and enable it for DMx platform
To: Sekhar Nori <nsekhar@ti.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LMML <linux-media@vger.kernel.org>,
        LFBDEV <linux-fbdev@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 3, 2013 at 3:25 PM, Sekhar Nori <nsekhar@ti.com> wrote:
> On 4/26/2013 11:16 AM, Prabhakar Lad wrote:
>> Hi Laurent,
>>
>> On Thu, Apr 25, 2013 at 2:32 AM, Laurent Pinchart
>> <laurent.pinchart@ideasonboard.com> wrote:
>>> Hi Prabhakar,
>>>
>>> Thank you for the patch.
>>>
>>> On Wednesday 24 April 2013 17:30:02 Prabhakar Lad wrote:
>>>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>>>
>>>> This patch series adds an fbdev driver for Texas
>>>> Instruments Davinci SoC.The display subsystem consists
>>>> of OSD and VENC, with OSD supporting 2 RGb planes and
>>>> 2 video planes.
>>>> http://focus.ti.com/general/docs/lit/
>>>> getliterature.tsp?literatureNumber=sprue37d&fileType=pdf
>>>>
>>>> A good amount of the OSD and VENC enabling code is
>>>> present in the kernel, and this patch series adds the
>>>> fbdev interface.
>>>>
>>>> The fbdev driver exports 4 nodes representing each
>>>> plane to the user - from fb0 to fb3.
>>>
>>> The obvious question is: why not a KMS driver instead ? :-)
>>>
>> I did go through the KMS model (thanks for pointing to your work and the video)
>> and it looks like this would require a fair amount of development, at this point
>> of time I would go with the current implementation and revisit on KMS model
>> at later point of time.
>
> But I doubt you will be able to sneak a new fbdev driver through. Last
> time I heard, Andrew is only taking in fixes not new features.
>
Then we have no choice left and go with KMS driver itself though it would take
some time since KMS is a new inclusion into DRM.

Regards,
--Prabhakar
