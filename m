Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095Ab3JGAuW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 20:50:22 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:60596 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021Ab3JGAuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 20:50:20 -0400
MIME-Version: 1.0
In-Reply-To: <20131007003247.GA21999@srcf.ucam.org>
References: <20131006203353.GA19795@srcf.ucam.org>
	<CAMP44s0N5xqD2W7-r-j1k3efo1k0qY2gCeqn+tbHsvOsrqOJgg@mail.gmail.com>
	<20131006204518.GA20077@srcf.ucam.org>
	<CAMP44s0GkVyw+PRYKqq7=MXFFtgUO9xCq6jTsoQV-rSRmC23yg@mail.gmail.com>
	<20131006205928.GA20296@srcf.ucam.org>
	<CAMP44s33CByGsRz7vsNAoOLnbEMY+fz73NzHJq07BzSuCEGJUg@mail.gmail.com>
	<20131006233106.GA21562@srcf.ucam.org>
	<CAMP44s1-vCgOkE_h1ZEmCA2WiQyLTOvnis2MOjdu8kdDB39kFg@mail.gmail.com>
	<20131006235702.GA21738@srcf.ucam.org>
	<CAMP44s3+GdeN6ZFxi6dKZ_1kyTgmgjTf4ET=pJnkSwoirZQMjw@mail.gmail.com>
	<20131007003247.GA21999@srcf.ucam.org>
Date: Sun, 6 Oct 2013 19:50:18 -0500
Message-ID: <CAMP44s1knbxW5C_tRSqopRLd+b2fXfuH=E3_L4EdOAUG4RMVhg@mail.gmail.com>
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

On Sun, Oct 6, 2013 at 7:32 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Sun, Oct 06, 2013 at 07:27:48PM -0500, Felipe Contreras wrote:
>
>> If _you_ want to add comments for each entry in the list you can do so
>> after this patch is applied.
>
> If you want to participate in a collaborative development effort you
> should pay attention to other people's concerns.

I did that when I listened to your comment, and I argued against it.

Disagreeing is not the same as not paying attention.

> I don't get the final
> say in whether or not this patch gets merged, but there's a decent
> chance that I'm going to be the one who has to remove the entries again
> once the backlight mess is fixed up. My life would be significantly
> easier if the entries are unambiguously identified in such a way that I
> can remove them without having to dig through git history to figure out
> where each came from.

And a *single* comment on top of this group entries achieves that just
fine. You haven't provided a single argument as to why that wouldn't
be the case.

In fact, you are the one that is not paying attention.

> Is that really an unreasonable request?

That wasn't a request, that was an explanation of what would make your
life easier.

And if uncommented entries is a problem for you, you already have that
problem, because the entries to remove are already there, uncommented.
The original patch I sent had a comment, so that's not my fault.

This patch would not make your life any harder, so that is a red
herring. The problem is already there.

-- 
Felipe Contreras
