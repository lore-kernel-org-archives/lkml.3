Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022Ab3C0Oo2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 10:44:28 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:54413 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab3C0OoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 10:44:25 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdaduNaUj0rZQjFmCbwWhK_CN_EnyRGNwut59bTCWp-PXA@mail.gmail.com>
References: <20130313113203.30133.49539.sendpatchset@w520>
	<1670937.hEFtzrbkf6@avalon>
	<CANqRtoSDc6YfnotMR2aw4niEYyjn1C7JRu4WciyKsP-QT+j4LA@mail.gmail.com>
	<1938905.m8UJXV94pZ@avalon>
	<CANqRtoRBfjXgGt4_niN3m5ULVQVQXBBARLUkNPyeDnZLatgXKA@mail.gmail.com>
	<CACRpkdaduNaUj0rZQjFmCbwWhK_CN_EnyRGNwut59bTCWp-PXA@mail.gmail.com>
Date: Wed, 27 Mar 2013 23:44:24 +0900
Message-ID: <CANqRtoRNj6V51V=URATdgBw4ugq2TUoTs3_A8j16nG9G1ZvQ1Q@mail.gmail.com>
Subject: Re: [PATCH 00/03] gpio: Renesas R-Car GPIO driver update
From: Magnus Damm <magnus.damm@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        grant.likely@secretlab.ca, horms@verge.net.au
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 9:34 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Tue, Mar 19, 2013 at 4:36 AM, Magnus Damm <magnus.damm@gmail.com> wrote:
>> On Thu, Mar 14, 2013 at 10:13 PM, Laurent Pinchart
>> <laurent.pinchart@ideasonboard.com> wrote:
>
>>> When submitting new drivers I usually try not to make the development history
>>> visible to mainline. It brings little additional value (beside possibly making
>>> backporting a bit easier, but in the devm_* case that shouldn't be a problem,
>>> unless Simon thinks otherwise) but adds review complexity, as reviewers need
>>> to validate the intermediate versions as well. More patches also mean more
>>> potential bisection breakages.
>>
>> Huh, it seems that my point of view is the total opposite. I see that
>> using incremental patches to show new development would make review
>> _easier_. Perhaps that's not the case for most people.
>
> As subsystem maintainer what I don't want to see is a patch that
> at one point breaks something in some configuration and then later
> fixes it. Then I strongly prefer squashing. (Greg also mentions this
> in one of his seminars.)

Sure, I totally agree. I strongly dislike when people introduce
breakage and then fix it later in the same series. It's pretty obvious
to me, each incremental step needs to work by itself - if it doesn't
then it should be reworked before it gets merged. I personally prefer
to separate features from fixes. Fixes are always folded into the
original patch.

> What really makes me mad is the the above pattern + claim that
> it must be done in that way to preserve authorship. Like legaleaze
> or credit is more important that functionality.
>
> If all patches are bisectable and perfectly fine then whether you
> take 8 stops when driving to Rome or just drive there in one
> big stretch is more a technical, secondary thing. Do whatever you
> like as long as all commits build and boot.

I suppose I prefer to stop for coffee in every village then. =)

/ magnus
