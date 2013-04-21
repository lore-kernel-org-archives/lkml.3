Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027Ab3DUJdQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 05:33:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752747Ab3DUJdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 05:33:14 -0400
Message-ID: <5173B254.7050804@redhat.com>
Date: Sun, 21 Apr 2013 06:33:08 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Andrey Smirnov <andrew.smirnov@gmail.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 00/12] Driver for Si476x series of chips
References: <1366304318-29620-1-git-send-email-andrew.smirnov@gmail.com> <20130419213152.GD11866@zurbaran> <CAHQ1cqGnDvO+wkfdO-o-4JSBgT=0TEww01NM1+o7g=1Hy0QNxw@mail.gmail.com>
In-Reply-To: <CAHQ1cqGnDvO+wkfdO-o-4JSBgT=0TEww01NM1+o7g=1Hy0QNxw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 21-04-2013 02:53, Andrey Smirnov escreveu:
>> I applied all the MFD patches from this patchset (All 4 first ones), plus a
>> follow up one for fixing the i2c related warning.
>> I also squashed the REGMAP_I2C dependency into patch #4.
>> It's all in mfd-next now, I'd appreciate if you could double check it's all
>> fine.
>
> I checked out latest
> git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-next.git and
> applied patches 5 - 10, 12. There doesn't seem to be any problems, so
> I think MFD part of the driver is good to go.
>
>>
>> Mauro will take the rest, we made sure there won't be any merge conflict
>> between our trees.
>
> Mauro, I am not sure if you need me to rebase any of the patches(it
> doesn't seem like you had a chance to make any further changes related
> to this driver in media tree), but if you do, ping me and I'll get on
> it.

No, I don't need. The V4L parts are on my experimental tree:

http://git.linuxtv.org/mchehab/experimental.git/shortlog/refs/heads/si476x

I'll just merge it at the main tree or as a topic branch later today
or (more likely) tomorrow.

Please ping me today if you find anything wrong there.

Regards,
Mauro
