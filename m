Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab3JSCaM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 22:30:12 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:40669 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754801Ab3JSCaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 22:30:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAANYUdCUg4GM5YX8KkokgqBGaUJjrtcHrkWaQEyhxUcivYnqMQ@mail.gmail.com>
References: <1380820383-23336-1-git-send-email-felipe.contreras@gmail.com>
	<CAMP44s1_2VHf+FWkuQxLyYvhSRwnUwhDQTxi5YrOt-ON1OCNTQ@mail.gmail.com>
	<CAANYUdCUg4GM5YX8KkokgqBGaUJjrtcHrkWaQEyhxUcivYnqMQ@mail.gmail.com>
Date: Fri, 18 Oct 2013 21:30:08 -0500
Message-ID: <CAMP44s3WowFAGMGDwEGGC6CiOsUpdwi7EP9=ZSMi6uv3edTpZA@mail.gmail.com>
Subject: Re: [PATCH] acpi: update win8 OSI blacklist
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Stefan Hellermann <stefan@the2masters.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 5:43 AM, Stefan Hellermann
<stefan@the2masters.de> wrote:
> 2013/10/3 Felipe Contreras <felipe.contreras@gmail.com>
>>
>> On Thu, Oct 3, 2013 at 12:13 PM, Felipe Contreras
>> <felipe.contreras@gmail.com> wrote:
>> > More people have reported they need this for their machines to work
>> > correctly.
>> >
>> > https://bugzilla.kernel.org/show_bug.cgi?id=60682
>>
>> Reported-by: Stefan Hellermann <bugzilla.kernel.org@the2masters.de>
>
>
> That's not entirely correct! I reported bios version 2.52 is affected, but
> 2.54 is fixed. I think we should match all Lenovo 3259*, but only bios
> version < 2.54

As far as I know there's no way to do a match like that. So we have to
choose, either we apply the blacklist for all, or for none. Since
removing the win8 OSI doesn't cause any negative effects in 2.54, I
say we would do the former.

-- 
Felipe Contreras
