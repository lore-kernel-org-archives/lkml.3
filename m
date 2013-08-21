Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab3HUSLO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 14:11:14 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:40867 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab3HUSLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 14:11:11 -0400
MIME-Version: 1.0
In-Reply-To: <5214E65F.50101@wwwdotorg.org>
References: <CAN8TOE_8f_vhCAhRaBGXk9=F8=-2YtY5eSNgypSuxiL5z-B-=Q@mail.gmail.com>
	<5214E65F.50101@wwwdotorg.org>
Date: Wed, 21 Aug 2013 11:11:09 -0700
Message-ID: <CAN8TOE9QZo-G4fpqhxYiQaG=j0v1dKLsZu7AgLokeLypAu11kw@mail.gmail.com>
Subject: Re: [Device-tree] mailing list responsiveness and discoverability
From: Brian Norris <computersforpeace@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>, devicetree@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 9:10 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 08/20/2013 08:25 PM, Brian Norris wrote:
>> Hello device tree maintainers,
>>
>> I (sub)maintain the Linux MTD subsystem and hang out on the
>> linux-mtd@infradead.org mailing list. I have been seeing an increasing
>> number of submissions that involve device-tree changes. Many of these
>> changes are ill thought out and may even cause ABI breakage.
>>
>> According to discussions I've seen on LKML, you want to see better
>> bindings merged into the kernel, and you want to maintain more control
>> over the acceptance of bindings in general. However, I see a few
>> problems that have inhibited this.
>>
>> (1) Mailing list change: it just so happens that you recently moved
>> your mailing list to @vger.kernel.org. Some people are still CC'ing
>> the old one (if they CC any DT list at all). I'm not sure what can be
>> done about this, exactly. Perhaps a forwarding rule + a warning
>> response would have been better for a transition period, rather than
>> just shutting down and rejecting from the old one.
>
> Indeed.

Grant, can you do anything about this?

>> (2) Responsiveness: when we finally do CC devicetree@vger.kernel.org,
>> I don't see much feedback, even for those which (when I get around to
>> reviewing them myself) look like they have obvious issues that
>> device-tree maintainers should care about.
>
> The problem here is that the mail volume is extremely high. Even keeping
> up with the content that I'm explicitly CC'd on is difficult, let alone
> the stuff that goes to the list that doesn't CC the binding maintainers.

In the few hours I have been subscribed to the devicetree list, I
already understand this point. Other than avoiding the old mailing
list, then I don't think there's much we can do.

Brian
