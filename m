Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521Ab3C0MeZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 08:34:25 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:37603 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab3C0MeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 08:34:24 -0400
MIME-Version: 1.0
In-Reply-To: <CANqRtoRBfjXgGt4_niN3m5ULVQVQXBBARLUkNPyeDnZLatgXKA@mail.gmail.com>
References: <20130313113203.30133.49539.sendpatchset@w520>
	<1670937.hEFtzrbkf6@avalon>
	<CANqRtoSDc6YfnotMR2aw4niEYyjn1C7JRu4WciyKsP-QT+j4LA@mail.gmail.com>
	<1938905.m8UJXV94pZ@avalon>
	<CANqRtoRBfjXgGt4_niN3m5ULVQVQXBBARLUkNPyeDnZLatgXKA@mail.gmail.com>
Date: Wed, 27 Mar 2013 13:34:23 +0100
Message-ID: <CACRpkdaduNaUj0rZQjFmCbwWhK_CN_EnyRGNwut59bTCWp-PXA@mail.gmail.com>
Subject: Re: [PATCH 00/03] gpio: Renesas R-Car GPIO driver update
From: Linus Walleij <linus.walleij@linaro.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        grant.likely@secretlab.ca, horms@verge.net.au
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 4:36 AM, Magnus Damm <magnus.damm@gmail.com> wrote:
> On Thu, Mar 14, 2013 at 10:13 PM, Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:

>> When submitting new drivers I usually try not to make the development history
>> visible to mainline. It brings little additional value (beside possibly making
>> backporting a bit easier, but in the devm_* case that shouldn't be a problem,
>> unless Simon thinks otherwise) but adds review complexity, as reviewers need
>> to validate the intermediate versions as well. More patches also mean more
>> potential bisection breakages.
>
> Huh, it seems that my point of view is the total opposite. I see that
> using incremental patches to show new development would make review
> _easier_. Perhaps that's not the case for most people.

As subsystem maintainer what I don't want to see is a patch that
at one point breaks something in some configuration and then later
fixes it. Then I strongly prefer squashing. (Greg also mentions this
in one of his seminars.)

What really makes me mad is the the above pattern + claim that
it must be done in that way to preserve authorship. Like legaleaze
or credit is more important that functionality.

If all patches are bisectable and perfectly fine then whether you
take 8 stops when driving to Rome or just drive there in one
big stretch is more a technical, secondary thing. Do whatever you
like as long as all commits build and boot.

Yours,
Linus Walleij
