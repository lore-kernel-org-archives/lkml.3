Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763014Ab3ECJ4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 05:56:20 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56545 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754431Ab3ECJ4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 05:56:15 -0400
Message-ID: <51838994.7070805@ti.com>
Date: Fri, 3 May 2013 15:25:32 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LMML <linux-media@vger.kernel.org>,
        LFBDEV <linux-fbdev@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: Re: [PATCH 0/6] Davinci fbdev driver and enable it for DMx platform
References: <1366804808-22720-1-git-send-email-prabhakar.csengg@gmail.com> <1780031.B4OAypccep@avalon> <CA+V-a8sLD2dP1RLb8ibZDOsLCP8hhMNUTr-zzU1zx_2ALDaDrg@mail.gmail.com>
In-Reply-To: <CA+V-a8sLD2dP1RLb8ibZDOsLCP8hhMNUTr-zzU1zx_2ALDaDrg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/26/2013 11:16 AM, Prabhakar Lad wrote:
> Hi Laurent,
> 
> On Thu, Apr 25, 2013 at 2:32 AM, Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
>> Hi Prabhakar,
>>
>> Thank you for the patch.
>>
>> On Wednesday 24 April 2013 17:30:02 Prabhakar Lad wrote:
>>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>>
>>> This patch series adds an fbdev driver for Texas
>>> Instruments Davinci SoC.The display subsystem consists
>>> of OSD and VENC, with OSD supporting 2 RGb planes and
>>> 2 video planes.
>>> http://focus.ti.com/general/docs/lit/
>>> getliterature.tsp?literatureNumber=sprue37d&fileType=pdf
>>>
>>> A good amount of the OSD and VENC enabling code is
>>> present in the kernel, and this patch series adds the
>>> fbdev interface.
>>>
>>> The fbdev driver exports 4 nodes representing each
>>> plane to the user - from fb0 to fb3.
>>
>> The obvious question is: why not a KMS driver instead ? :-)
>>
> I did go through the KMS model (thanks for pointing to your work and the video)
> and it looks like this would require a fair amount of development, at this point
> of time I would go with the current implementation and revisit on KMS model
> at later point of time.

But I doubt you will be able to sneak a new fbdev driver through. Last
time I heard, Andrew is only taking in fixes not new features.

Thanks,
Sekhar
