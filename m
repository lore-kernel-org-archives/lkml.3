Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab3HARuW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 13:50:22 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:43448 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab3HARuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 13:50:20 -0400
MIME-Version: 1.0
In-Reply-To: <20130801174237.GA20121@srcf.ucam.org>
References: <37178266.QXgbv9rq0i@vostro.rjw.lan>
	<CAMP44s2LqiEGtS72FuTjsHUa1MH2kfaYHmcpNKMmAm2LnbFCCQ@mail.gmail.com>
	<20130731051421.GA15766@srcf.ucam.org>
	<CAMP44s2B=nQLnZm7gyYAJZgt_x3KszRZLUC=fom0t9=Eze+smA@mail.gmail.com>
	<20130731140010.GA24560@srcf.ucam.org>
	<CAMP44s1cLou9TMfLS+FHwPM_b3bG5HN1-hzgvhz0fVRCZ8XqWw@mail.gmail.com>
	<20130731175232.GA29987@srcf.ucam.org>
	<CAMP44s1c5pmiC2fvmRi9vFrJXb2zYUT_F=paM2LR_V+7THnFVg@mail.gmail.com>
	<20130731184724.GA30896@srcf.ucam.org>
	<CAMP44s25aRcK2bB=WLMkuD45fztFBNug8prArczRqZqzeEvj3A@mail.gmail.com>
	<20130801174237.GA20121@srcf.ucam.org>
Date: Thu, 1 Aug 2013 12:50:18 -0500
Message-ID: <CAMP44s3EgZBtv-ifO9b+VzmTBE2wejNK7RN3ERL0+imrXzgBCg@mail.gmail.com>
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

On Thu, Aug 1, 2013 at 12:42 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Thu, Aug 01, 2013 at 12:37:04PM -0500, Felipe Contreras wrote:
>> On Wed, Jul 31, 2013 at 1:47 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>> > If we can't make an interface 100% consistent, we shouldn't pretend that
>> > the interface is 100% consistent. We can't, and so we don't. Setting a
>> > backlight value of 0 may turn the screen off, and userspace needs to
>> > deal with that.
>>
>> This is insanity; we can never guarantee 100% of anything.
>>
>> Better is better. And 99% is better than 90%
>
> An interface that describes reality is better than one that doesn't. But
> hey, feel free to disagree and post a patch for the ABI docs.

An interface that is useful to the user is better than one that is not.

-- 
Felipe Contreras
