Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751325AbaEWHlB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 03:41:01 -0400
Received: from mail-qg0-f50.google.com ([209.85.192.50]:49141 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbaEWHk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 03:40:56 -0400
MIME-Version: 1.0
In-Reply-To: <CAOesGMjyk=n7MyVisfjYze9UuEb7XNv5O+c1Tndc+q1Q=PEetQ@mail.gmail.com>
References: <1400522571-10799-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<CAPDyKFo8CdyDbJEP0GkFTHdzpkyRBZEp-jAyrU4y8qi__zChkA@mail.gmail.com>
	<CAOesGMjyk=n7MyVisfjYze9UuEb7XNv5O+c1Tndc+q1Q=PEetQ@mail.gmail.com>
Date: Fri, 23 May 2014 09:40:55 +0200
Message-ID: <CAPDyKFp7Sf0sdReOyC8V_-F6ozB6Vh8CEbc+R7eoe6H4t-OmYA@mail.gmail.com>
Subject: Re: [PATCH RESEND] mmc: dove: fix missing MACH_DOVE dependency
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Olof Johansson <olof@lixom.net>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Chris Ball <chris@printf.net>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 May 2014 09:16, Olof Johansson <olof@lixom.net> wrote:
> On Thu, May 22, 2014 at 2:09 AM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
>> On 19 May 2014 20:02, Sebastian Hesselbarth
>> <sebastian.hesselbarth@gmail.com> wrote:
>>> DT-enabled Dove moved over from ARCH_DOVE in mach-dove to MACH_DOVE in
>>> mach-mvebu. As non-DT ARCH_DOVE will stay to rot for a while, add a new
>>> DT-only MACH_DOVE Kconfig. This slipped through the cracks and now is
>>> a fix to allow to build Dove's SDHCI driver for mach-mvebu on v3.15-rc.
>>>
>>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>>> Acked-by: Jason Cooper <jason@lakedaemon.net>
>>
>> Thanks! Picked up for the PR I send to Chris.
>
> Ulf, you might consider adding your tree to linux-next if this is
> going to be a common work flow for you guys.

That's done already. :-) There are patches which makes this visible in
the MAINTAINERS as well, queued for 3.16.

git://git.linaro.org/people/ulf.hansson/mmc.git next

Though due to merge conflicts, during this release cycle, I didn't
want to queue any patches besides for the mmci host driver.

>
> It's partially up to Chris though, if he's OK with patches going into
> your branch more or less being guaranteed to make it into his as well.
>

Yes, we need to figure out a good work flow when using two separate
trees. Thanks for bringing this up!

Kind regards
Ulf Hansson
