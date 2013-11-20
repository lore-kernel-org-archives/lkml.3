Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928Ab3KTJvq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 04:51:46 -0500
Received: from mail-ve0-f182.google.com ([209.85.128.182]:40150 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357Ab3KTJvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 04:51:41 -0500
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
In-Reply-To: <20131119220829.27502.62997@capellas-linux>
References: <1384867831-15383-1-git-send-email-jhbird.choi@samsung.com>
	<27161890.Zx6CiZOMr8@amdc1032>
	<20131119220829.27502.62997@capellas-linux>
Date: Wed, 20 Nov 2013 18:51:41 +0900
X-Google-Sender-Auth: zqBVZUgyZ2PNcdZK80QH0-gzvTs
Message-ID: <CAJ0PZbSkDegFSwJoEHsZGGbXxtTDt419rdK+cn+E+bzmux9U7w@mail.gmail.com>
Subject: Re: [PATCH 4/4] PM / devfreq: Consider hibernation in pm notifier
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: Sebastian Capella <sebastian.capella@linaro.org>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Jonghwan Choi <jhbird.choi@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kukjin Kim <kgene.kim@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Samsung SoC <linux-samsung-soc@vger.kernel.org>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 7:08 AM, Sebastian Capella
<sebastian.capella@linaro.org> wrote:
> Quoting Bartlomiej Zolnierkiewicz (2013-11-19 06:50:05)
>> Hi,
>>
>> Are you planning to add hibernation support to ARM?
>>
>> If so then this should be stated somewhere in the patch description.
>>
>> OTOH if you are not going to add hibernation support to ARM I see
>> a little sense in adding hibernation support to ARM-only drivers..
>
> FYI, we at Linaro and a few others have been working on adding
> hibernation support for ARM.  I have not coordinated with Jonghwan
> however.

That is great.

We once tried to upstream hibernation support and forgot it for a while, too.
http://lists.infradead.org/pipermail/linux-arm-kernel/2010-December/036101.html

I have not coordinated with Jonghwan Choi, either.
However, it appears that some others are trying now, too.


Cheers,
MyungJoo

>
> Apoligies for the earlier toppost.
>
> Thanks,
>
> Sebastian Capella
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
MyungJoo Ham, Ph.D.
System S/W Lab, S/W Center, Samsung Electronics
