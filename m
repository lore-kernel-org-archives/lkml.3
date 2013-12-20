Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161015Ab3LTNao (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 08:30:44 -0500
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3770 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422817Ab3LTNak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 08:30:40 -0500
Message-ID: <52B4466A.2020700@xs4all.nl>
Date: Fri, 20 Dec 2013 14:30:18 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: Hans Verkuil <hans.verkuil@cisco.com>, devel@driverdev.osuosl.org,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH] media: davinci_vpfe: fix build error
References: <1387293923-27236-1-git-send-email-prabhakar.csengg@gmail.com> <CA+V-a8sdCuO1U3Egn62g_QivmVUEXzF4RgKbi-Ksm7JZEY-KKA@mail.gmail.com> <52B43DB0.8020107@xs4all.nl> <CA+V-a8tzXtPS5pjGqpno74-9s3gruJhBJ+WD23n1w2jsR7uZGA@mail.gmail.com>
In-Reply-To: <CA+V-a8tzXtPS5pjGqpno74-9s3gruJhBJ+WD23n1w2jsR7uZGA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

On 12/20/2013 02:02 PM, Prabhakar Lad wrote:
> Hi Hans,
> 
> On Fri, Dec 20, 2013 at 6:23 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> I just made a patch myself that I added to the pull request I just posted.
>>
>> You didn't CC me or CC the linux-media list when you posted your patch, so I
>> never saw it.
>>
> I dont know why this patch didnt make up in linux-media but its
> present DLOS [1].

If it's not mailed to linux-media, then it doesn't end up in linux-media patchwork,
and then I won't see it when I process pending patches.

While I am subscribed to DLOS I do not actually read it unless I know there is
something that I need to pay attention to.

> I posted it the same day when you pinged me about this issue.

I was a bit surprised that I didn't see a patch for this, you are very prompt
normally :-)

> Anyway your patch
> too didnt reach me and I also cannot find it in the ML. May be you
> directly issued the pull ?

I directly issued the pull. It was such a trivial change. 

Regards,

	Hans

> 
> [1] https://patchwork.kernel.org/patch/3362211/
> 
> Regards,
> --Prabhakar Lad
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
