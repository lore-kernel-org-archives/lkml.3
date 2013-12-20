Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030208Ab3LTNqh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 08:46:37 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:36193 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030186Ab3LTNqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 08:46:35 -0500
MIME-Version: 1.0
In-Reply-To: <52B4466A.2020700@xs4all.nl>
References: <1387293923-27236-1-git-send-email-prabhakar.csengg@gmail.com>
 <CA+V-a8sdCuO1U3Egn62g_QivmVUEXzF4RgKbi-Ksm7JZEY-KKA@mail.gmail.com>
 <52B43DB0.8020107@xs4all.nl> <CA+V-a8tzXtPS5pjGqpno74-9s3gruJhBJ+WD23n1w2jsR7uZGA@mail.gmail.com>
 <52B4466A.2020700@xs4all.nl>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 20 Dec 2013 19:16:13 +0530
Message-ID: <CA+V-a8tDZd3eKiJUKogTEJAuvYEn7a5HRberoeSpzFj-0DVfAA@mail.gmail.com>
Subject: Re: [PATCH] media: davinci_vpfe: fix build error
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Hans Verkuil <hans.verkuil@cisco.com>, devel@driverdev.osuosl.org,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

On Fri, Dec 20, 2013 at 7:00 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Prabhakar,
>
> On 12/20/2013 02:02 PM, Prabhakar Lad wrote:
>> Hi Hans,
>>
>> On Fri, Dec 20, 2013 at 6:23 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>> I just made a patch myself that I added to the pull request I just posted.
>>>
>>> You didn't CC me or CC the linux-media list when you posted your patch, so I
>>> never saw it.
>>>
>> I dont know why this patch didnt make up in linux-media but its
>> present DLOS [1].
>
> If it's not mailed to linux-media, then it doesn't end up in linux-media patchwork,
> and then I won't see it when I process pending patches.
>
> While I am subscribed to DLOS I do not actually read it unless I know there is
> something that I need to pay attention to.
>
This didnt land into linux-media becuase may be I sent it throught TI's network
I usually send it via my home network.

>> I posted it the same day when you pinged me about this issue.
>
> I was a bit surprised that I didn't see a patch for this, you are very prompt
> normally :-)
>
 :)
>> Anyway your patch
>> too didnt reach me and I also cannot find it in the ML. May be you
>> directly issued the pull ?
>
> I directly issued the pull. It was such a trivial change.
>
No problem as long as its fixed :)

Thanks,
--Prabhakar Lad
