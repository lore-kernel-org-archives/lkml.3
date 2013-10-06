Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab3JFX1c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 19:27:32 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:41263 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754854Ab3JFX1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 19:27:30 -0400
MIME-Version: 1.0
In-Reply-To: <20131006205928.GA20296@srcf.ucam.org>
References: <1380820383-23336-1-git-send-email-felipe.contreras@gmail.com>
	<20131004161226.GA22784@srcf.ucam.org>
	<CAMP44s0tqKBgUTzFnbTMqDVVWLcaDC5VKd9mq_w+T_Yu19KXqQ@mail.gmail.com>
	<20131006203353.GA19795@srcf.ucam.org>
	<CAMP44s0N5xqD2W7-r-j1k3efo1k0qY2gCeqn+tbHsvOsrqOJgg@mail.gmail.com>
	<20131006204518.GA20077@srcf.ucam.org>
	<CAMP44s0GkVyw+PRYKqq7=MXFFtgUO9xCq6jTsoQV-rSRmC23yg@mail.gmail.com>
	<20131006205928.GA20296@srcf.ucam.org>
Date: Sun, 6 Oct 2013 18:27:28 -0500
Message-ID: <CAMP44s33CByGsRz7vsNAoOLnbEMY+fz73NzHJq07BzSuCEGJUg@mail.gmail.com>
Subject: Re: [PATCH] acpi: update win8 OSI blacklist
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 6, 2013 at 3:59 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Sun, Oct 06, 2013 at 03:51:05PM -0500, Felipe Contreras wrote:
>> On Sun, Oct 6, 2013 at 3:45 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>> > On Sun, Oct 06, 2013 at 03:40:42PM -0500, Felipe Contreras wrote:
>> >
>> >> In case you didn't hear, the plan was to add an entry if a user
>> >> reports the backlight not working correctly, and acpi_osi="!Windows
>> >> 2012" fixing it with no negative effects. and that's what users did in
>> >> bug #60682.
>> >
>> > So add that to each entry you're adding to the list.
>>
>> No. These entries are already there, I'm merely updating it. I added a
>> comment before the list, but the comment was removed.
>
> There's no point in having a comment that describes a list, because
> someone will inevitably reorder them or insert things in between at some
> point. Add a comment per entry.

>From acpi_osi_dmi_table:

/*
* BIOS invocation of _OSI(Linux) is almost always a BIOS bug.
* Linux ignores it, except for the machines enumerated below.
*/

-- 
Felipe Contreras
