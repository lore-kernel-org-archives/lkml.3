Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab3HDA15 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 20:27:57 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:42100 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab3HDA1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 20:27:55 -0400
MIME-Version: 1.0
In-Reply-To: <1375572464.1988.4.camel@ThinkPad-X230.localdomain>
References: <2052880.bHfzt6NKt5@vostro.rjw.lan>
	<6100577.WGRZRabKGy@vostro.rjw.lan>
	<CAMP44s1Knox3oVt3-ePkDHxa2uNQAFVFRwmVTATNknWA46b_Uw@mail.gmail.com>
	<1963015.Y2AObmEn2f@vostro.rjw.lan>
	<1375546086.1988.2.camel@ThinkPad-X230.localdomain>
	<CAMP44s2HSEnhWfgtvSmu3K-nrWzHnxfj44hpvAVerRQq-dUABg@mail.gmail.com>
	<1375572464.1988.4.camel@ThinkPad-X230.localdomain>
Date: Sat, 3 Aug 2013 19:27:53 -0500
Message-ID: <CAMP44s2=EGcmKPgbdrEJpnyCMStD_JPDOOuYfPtnsTB8k+1UTw@mail.gmail.com>
Subject: Re: [GIT PULL] ACPI and power management fixes for v3.11-rc4
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Igor Gnatenko <i.gnatenko.brain@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 3, 2013 at 6:27 PM, Igor Gnatenko
<i.gnatenko.brain@gmail.com> wrote:
> On Sat, 2013-08-03 at 15:21 -0500, Felipe Contreras wrote:
>> On Sat, Aug 3, 2013 at 11:08 AM, Igor Gnatenko
>> <i.gnatenko.brain@gmail.com> wrote:
>>
>> > I am opposed to this patch. On ThinkPad X230 I had problems with it.
>> > Felipe, come over to dark side. They have cookies.
>>
>> And v3.11-rc3 works's fine out-of-the box?
>>
>
> rc2 work's fine. Since rc3 Rafael reverted patch and I think backlight
> broken again (I don't have time to check rc3 yet).

You think?

We are talking about this patch [1]. Did you apply that patch on top
of rc3 and booted without any arguments?

If you did, what problems *exactly* did you have?

[1] https://bugzilla.kernel.org/attachment.cgi?id=107084&action=diff&context=patch&collapsed=&headers=1&format=raw

-- 
Felipe Contreras
