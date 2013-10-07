Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130Ab3JGBBk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 21:01:40 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:33283 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755049Ab3JGBBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 21:01:36 -0400
MIME-Version: 1.0
In-Reply-To: <20131007005355.GA22211@srcf.ucam.org>
References: <20131006204518.GA20077@srcf.ucam.org>
	<CAMP44s0GkVyw+PRYKqq7=MXFFtgUO9xCq6jTsoQV-rSRmC23yg@mail.gmail.com>
	<20131006205928.GA20296@srcf.ucam.org>
	<CAMP44s33CByGsRz7vsNAoOLnbEMY+fz73NzHJq07BzSuCEGJUg@mail.gmail.com>
	<20131006233106.GA21562@srcf.ucam.org>
	<CAMP44s1-vCgOkE_h1ZEmCA2WiQyLTOvnis2MOjdu8kdDB39kFg@mail.gmail.com>
	<20131006235702.GA21738@srcf.ucam.org>
	<CAMP44s3+GdeN6ZFxi6dKZ_1kyTgmgjTf4ET=pJnkSwoirZQMjw@mail.gmail.com>
	<20131007003247.GA21999@srcf.ucam.org>
	<CAMP44s1knbxW5C_tRSqopRLd+b2fXfuH=E3_L4EdOAUG4RMVhg@mail.gmail.com>
	<20131007005355.GA22211@srcf.ucam.org>
Date: Sun, 6 Oct 2013 20:01:34 -0500
Message-ID: <CAMP44s0jCvzrBDuiGe=q=tJyQGSGt47aAeJJyPgEtrQB_qXq1Q@mail.gmail.com>
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

On Sun, Oct 6, 2013 at 7:53 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Sun, Oct 06, 2013 at 07:50:18PM -0500, Felipe Contreras wrote:
>> On Sun, Oct 6, 2013 at 7:32 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>> > I don't get the final
>> > say in whether or not this patch gets merged, but there's a decent
>> > chance that I'm going to be the one who has to remove the entries again
>> > once the backlight mess is fixed up. My life would be significantly
>> > easier if the entries are unambiguously identified in such a way that I
>> > can remove them without having to dig through git history to figure out
>> > where each came from.
>>
>> And a *single* comment on top of this group entries achieves that just
>> fine. You haven't provided a single argument as to why that wouldn't
>> be the case.
>
> No, it demonstrably doesn't. The comments that do exist refer to only a
> subset of the entries underneath them.

That's not true.

/*
* BIOS invocation of _OSI(Linux) is almost always a BIOS bug.
* Linux ignores it, except for the machines enumerated below.
*/

> Having a per-entry comment is significantly clearer.

That is your opinion, it's not a demonstrable fact.

And just to be clear, you are saying that in the following code, you
have no idea which statements correspond to which sections. Am I
correct?

/* section 1 */

a();
b();
c();

/* section 2 */

d();
e();

/* section 3 */

f();

And once again, the problem with the **current** format of the list is
orthogonal to this patch.

-- 
Felipe Contreras
