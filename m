Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609Ab3HASLg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 14:11:36 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:54127 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558Ab3HASLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 14:11:34 -0400
MIME-Version: 1.0
In-Reply-To: <20130801180144.GA20520@srcf.ucam.org>
References: <20130731051421.GA15766@srcf.ucam.org>
	<CAMP44s2B=nQLnZm7gyYAJZgt_x3KszRZLUC=fom0t9=Eze+smA@mail.gmail.com>
	<20130731140010.GA24560@srcf.ucam.org>
	<CAMP44s1cLou9TMfLS+FHwPM_b3bG5HN1-hzgvhz0fVRCZ8XqWw@mail.gmail.com>
	<20130731175232.GA29987@srcf.ucam.org>
	<CAMP44s1c5pmiC2fvmRi9vFrJXb2zYUT_F=paM2LR_V+7THnFVg@mail.gmail.com>
	<20130731184724.GA30896@srcf.ucam.org>
	<CAMP44s25aRcK2bB=WLMkuD45fztFBNug8prArczRqZqzeEvj3A@mail.gmail.com>
	<20130801174237.GA20121@srcf.ucam.org>
	<CAMP44s3EgZBtv-ifO9b+VzmTBE2wejNK7RN3ERL0+imrXzgBCg@mail.gmail.com>
	<20130801180144.GA20520@srcf.ucam.org>
Date: Thu, 1 Aug 2013 13:11:31 -0500
Message-ID: <CAMP44s2OOX8=tumzwiK3_PRJCxfLfDECrz3dPbzNPiUOuYT8TA@mail.gmail.com>
Subject: Re: [REGRESSION/PATCH] acpi: blacklist win8 OSI for ASUS Zenbok Prime UX31A
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Aaron Lu <aaron.lwe@gmail.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Len Brown <lenb@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 1, 2013 at 1:01 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Thu, Aug 01, 2013 at 12:50:18PM -0500, Felipe Contreras wrote:
>> On Thu, Aug 1, 2013 at 12:42 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>> > An interface that describes reality is better than one that doesn't. But
>> > hey, feel free to disagree and post a patch for the ABI docs.
>>
>> An interface that is useful to the user is better than one that is not.
>
> The interface is useful.

Not 100% useful.

If you are going to claim that 99% true is not true, then useful but
inconsistent is not useful.

I think it is useful, and I think it can be consistent if we want it to.

> There are plenty of machines out there that
> disable the backlight at minimum brightness setting (see every Apple,
> for example), and assuming otherwise has always been incorrect. But,
> like I said, send the patch.

The key word in "every Apple" is *every*; what level 0 does in every
apple is consistent. If 0 should turn off the screen, it should do so
on all Linux machines.

I will investigate and prepare an update to the documentation and the
quirks to do so.

-- 
Felipe Contreras
