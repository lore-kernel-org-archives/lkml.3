Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602AbaGNRBr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 13:01:47 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:52953 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756224AbaGNRBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 13:01:38 -0400
MIME-Version: 1.0
In-Reply-To: <20140714141231.GM25880@mwanda>
References: <1405278681-3348-1-git-send-email-peter.senna@gmail.com>
	<20140713193647.GA31010@kroah.com>
	<20140714085932.GA2958@hp-peter.rsr.lip6.fr>
	<20140714141231.GM25880@mwanda>
Date: Mon, 14 Jul 2014 19:01:37 +0200
Message-ID: <CA+MoWDpQBQYqZ2ZLM3-17cfQQ0LjMcv702ZxVv10M5Wd895rJg@mail.gmail.com>
Subject: Re: [PATCH V2 1/4] staging: vt6556: Cleanup coding style issues
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org,
        Malcolm Priestley <tvboxspy@gmail.com>,
        kernel-janitors@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Forest Bond <forest@alittletooquiet.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<note>
I'm not trying to push my changes over the rules. I'm trying to
understand the problem, to avoid creating similar noise in the future.
</note>

Now I understand that the problem with the series of 4 patches is that
the subject is the same on the 4 patches. Having the same subject in 4
patches is not good. I got this one.

But I have no clue why joining 4 cleanup patches into 1 is bad. The
patches are all for the same driver, are all silencing checkpatch
warnings, and even the typedef stuff was reported by checkpatch. The
commit message of the single patch describes it all. If the subject of
the series is the problem, why not make a single patch instead of a
series of similar patches? It made sense from my perspective. So what
is the problem in re-submit 4 similar patches as a single patch?

On Mon, Jul 14, 2014 at 4:12 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> Since you're going to redo this patch anyway, I may as well give you
> the normal feedback for these kinds of patches.
>
>> >From 69cd87aca39730c0578592d1296b738f7f223f29 Mon Sep 17 00:00:00 2001
>> From: Peter Senna Tschudin <peter.senna@gmail.com>
>> Date: Mon, 14 Jul 2014 10:28:42 +0200
>> Subject: [PATCH V3] staging: vt6556: Cleanup coding style issues
>>
>> This patch cleanup coding style issues reported by checkpatch.
>>
>> This typedef, reported by checkpatch, was removed from card.h:
>> typedef enum _CARD_PHY_TYPE {
>>     PHY_TYPE_AUTO = 0,
>>     PHY_TYPE_11B,
>>     PHY_TYPE_11G,
>>     PHY_TYPE_11A
>> } CARD_PHY_TYPE, *PCARD_PHY_TYPE;
>>
>> The following typedefs were removed, but enums were kept at device.h:
>>  - typedef enum __device_msg_level
>>  - typedef enum __DEVICE_NDIS_STATUS
>>
>
> Break this kind of patch into patches which fix one type of mistake per
> patch:
> patch 1: fix whitespace stuff
> patch 2: remove useless returns
> patch 3: remove typedefs
> etc.
>
>> -//{{RobertYu:20060515, new BB setting for VT3226D0
>> +/* {{RobertYu:20060515, new BB setting for VT3226D0 */
>
> Just delete these, because we have version control.
>
> regards,
> dan carpenter
>



-- 
Peter
