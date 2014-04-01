Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961AbaDAGkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 02:40:45 -0400
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4135 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbaDAGkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 02:40:43 -0400
Message-ID: <533A5F50.30105@xs4all.nl>
Date: Tue, 01 Apr 2014 08:40:16 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.4.0
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH 1/2] media: davinci: vpif capture: upgrade the driver
 with v4l offerings
References: <1396277573-9513-1-git-send-email-prabhakar.csengg@gmail.com> <1396277573-9513-2-git-send-email-prabhakar.csengg@gmail.com> <5339840D.9000702@xs4all.nl> <CA+V-a8s_mZNEuN0JHH_rpJU=zab57Q_LfLT_onwj0=ykgoUm0g@mail.gmail.com>
In-Reply-To: <CA+V-a8s_mZNEuN0JHH_rpJU=zab57Q_LfLT_onwj0=ykgoUm0g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2014 07:24 PM, Prabhakar Lad wrote:
> Hi Hans,
> 
> On Mon, Mar 31, 2014 at 8:34 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> Hi Prabhakar,
>>
>> This looks really nice!
>>
> Writing a video driver has become really easy with almost 90% of work
> done by v4l core itself :)

That was the idea!

>> I'll do a full review on Friday, but in the meantime can you post the output
> OK.
> 
>> of 'v4l2-compliance -s' using the latest v4l2-compliance version? I've made
>> some commits today, so you need to do a git pull of v4l-utils.git.
>>
> I had compilation failures for v4l2-compliance following is the patch
> fixing that, (I am
> facing some issues in cross compilation once done I'll post the o/p of it)

I fixed the 'friend' issue (weird that it didn't fail with my g++) and the other
issue was already fixed yesterday.

Regards,

	Hans
