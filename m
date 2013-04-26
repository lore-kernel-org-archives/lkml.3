Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758823Ab3DZFqv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 01:46:51 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:61922 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010Ab3DZFqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 01:46:49 -0400
MIME-Version: 1.0
In-Reply-To: <1780031.B4OAypccep@avalon>
References: <1366804808-22720-1-git-send-email-prabhakar.csengg@gmail.com> <1780031.B4OAypccep@avalon>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 26 Apr 2013 11:16:28 +0530
Message-ID: <CA+V-a8sLD2dP1RLb8ibZDOsLCP8hhMNUTr-zzU1zx_2ALDaDrg@mail.gmail.com>
Subject: Re: [PATCH 0/6] Davinci fbdev driver and enable it for DMx platform
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LMML <linux-media@vger.kernel.org>,
        LFBDEV <linux-fbdev@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Thu, Apr 25, 2013 at 2:32 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Prabhakar,
>
> Thank you for the patch.
>
> On Wednesday 24 April 2013 17:30:02 Prabhakar Lad wrote:
>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>
>> This patch series adds an fbdev driver for Texas
>> Instruments Davinci SoC.The display subsystem consists
>> of OSD and VENC, with OSD supporting 2 RGb planes and
>> 2 video planes.
>> http://focus.ti.com/general/docs/lit/
>> getliterature.tsp?literatureNumber=sprue37d&fileType=pdf
>>
>> A good amount of the OSD and VENC enabling code is
>> present in the kernel, and this patch series adds the
>> fbdev interface.
>>
>> The fbdev driver exports 4 nodes representing each
>> plane to the user - from fb0 to fb3.
>
> The obvious question is: why not a KMS driver instead ? :-)
>
I did go through the KMS model (thanks for pointing to your work and the video)
and it looks like this would require a fair amount of development, at this point
of time I would go with the current implementation and revisit on KMS model
at later point of time.

Regards,
--Prabhakar
