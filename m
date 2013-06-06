Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532Ab3FFPFL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 11:05:11 -0400
Received: from mail-qe0-f45.google.com ([209.85.128.45]:61726 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab3FFPFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 11:05:09 -0400
MIME-Version: 1.0
X-Originating-IP: [2001:470:1f05:1640:55bd:10dd:64f4:fa4]
In-Reply-To: <20130606140250.GA4839@thunk.org>
References: <CAPweEDx3mAy40BZrzrKPRbvg7vKMj7KevDQ3m_v4p6Yo50eSGg@mail.gmail.com>
	<1370475609.20454.44.camel@localhost>
	<CAPweEDwS3tR=wh-bZJb3vqR8fVQra=3XxDitowGRdH9c7WRfmQ@mail.gmail.com>
	<1733666.lHUBcfUXq9@flatron>
	<CAPweEDzYLDzh_-OWU61dtVhajZ40QpQgZKHFYDsh3FgF=r9_ag@mail.gmail.com>
	<20130606140250.GA4839@thunk.org>
Date: Thu, 6 Jun 2013 08:05:08 -0700
Message-ID: <CAOesGMgukawVUN978xQARwOWBEhVQQXCPKYQ2eua8yAVgH5HCg@mail.gmail.com>
Subject: Re: [Arm-netbook] getting allwinner SoC support upstream (was Re:
 Uploading linux (3.9.4-1))
From: Olof Johansson <olof@lixom.net>
To: "Theodore Ts'o" <tytso@mit.edu>, "luke.leighton" <luke.leighton@gmail.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux on small ARM machines 
	<arm-netbook@lists.phcomp.co.uk>,
        devicetree-discuss <devicetree-discuss@ozlabs.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        debian-arm@lists.debian.org, "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        debian-kernel@lists.debian.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 6, 2013 at 7:02 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Thu, Jun 06, 2013 at 01:24:57PM +0100, luke.leighton wrote:
>> On Thu, Jun 6, 2013 at 1:01 AM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
>>
>> > I don't see any other solution here than moving all the Allwinner code to
>> > DT (as it has been suggested in this thread several times already), as
>> > this is the only hardware description method supported by ARM Linux.
>>
>>  i repeat again: please state, explicitly and unequivocably that you -
>> linux kernel developers - are happy that the reach of linux and
>> gnu/linux OSes is dramatically reduced due to this intransigent
>> position.
>
> But that's not a true statement.  You've said that Allwinner is
> perfectly happy to carry code out of tree, by constantly porting their
> hacks from mainline kernels.
>
> For some of their customers, this will be acceptable to them.  In
> those cases, Linux will still be in use.  Great!  So claiming that the
> reach of Linux will be "dramatically reduced" just is not a
> supportable position.
>
> For other (potential) customers, for whom mainline kernel support is
> critically important, they will choose other hardware solutions that
> are in the mainline kernel.
>
> I don't see the problem here.

This is all just a big storm in a cup. Mainline kernel support for
allwinner SoCs are already happening through hobby development by
Maxime Ripard and others. Allwinner are not yet actively
participating, but they're aware of it. The whole situation is a
non-issue.

If the vendor prefers to keep carrying their own code for a while,
they're free to. It makes more sense for them to move over to the
upstream code as they move forward with their kernel versions, but
they can do that on their own schedule.

We've seen all this before, it tends to turn out OK in the longer run.


-Olof
