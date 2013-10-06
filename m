Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342Ab3JFUkp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 16:40:45 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:58194 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380Ab3JFUko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 16:40:44 -0400
MIME-Version: 1.0
In-Reply-To: <20131006203353.GA19795@srcf.ucam.org>
References: <1380820383-23336-1-git-send-email-felipe.contreras@gmail.com>
	<20131004161226.GA22784@srcf.ucam.org>
	<CAMP44s0tqKBgUTzFnbTMqDVVWLcaDC5VKd9mq_w+T_Yu19KXqQ@mail.gmail.com>
	<20131006203353.GA19795@srcf.ucam.org>
Date: Sun, 6 Oct 2013 15:40:42 -0500
Message-ID: <CAMP44s0N5xqD2W7-r-j1k3efo1k0qY2gCeqn+tbHsvOsrqOJgg@mail.gmail.com>
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

On Sun, Oct 6, 2013 at 3:33 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Sun, Oct 06, 2013 at 03:29:10PM -0500, Felipe Contreras wrote:
>> On Fri, Oct 4, 2013 at 11:12 AM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>> > On Thu, Oct 03, 2013 at 12:13:03PM -0500, Felipe Contreras wrote:
>> >> More people have reported they need this for their machines to work
>> >> correctly.
>> >
>> > Can you add a comment to each indicating why they're being added so we
>> > can easily remove them again once the problem is fixed?
>>
>> Because that's what users report:
>> https://bugzilla.kernel.org/show_bug.cgi?id=60682
>
> Yes. For each entry, add a comment describing the specific bug seen.

In case you didn't hear, the plan was to add an entry if a user
reports the backlight not working correctly, and acpi_osi="!Windows
2012" fixing it with no negative effects. and that's what users did in
bug #60682.

-- 
Felipe Contreras
