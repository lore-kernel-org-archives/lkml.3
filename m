Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547AbaAHVCu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 16:02:50 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:58910 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757524AbaAHVCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 16:02:47 -0500
MIME-Version: 1.0
In-Reply-To: <20140108190758.GY31886@sirena.org.uk>
References: <1389201738-31406-1-git-send-email-lpapp@kde.org>
	<20140108180747.GT31886@sirena.org.uk>
	<CAOMwXhN8x0xHstrwsrxqXoE+n19TP=r1HJDCFOHs2O024HaY1w@mail.gmail.com>
	<20140108190758.GY31886@sirena.org.uk>
Date: Wed, 8 Jan 2014 21:02:47 +0000
X-Google-Sender-Auth: cGrR2OwaWSB_H-yobePSdZY1Dqw
Message-ID: <CAOMwXhMh6A8wZa3rtQHH1HpYU6PoZuWkPuSki64hOAnAZ-QZoQ@mail.gmail.com>
Subject: Re: [PATCH] include/linux/regmap.h: fix a couple of typos
From: Laszlo Papp <lpapp@kde.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 8, 2014 at 7:07 PM, Mark Brown <broonie@kernel.org> wrote:
> On Wed, Jan 08, 2014 at 06:59:57PM +0000, Laszlo Papp wrote:
>> On Wed, Jan 8, 2014 at 6:07 PM, Mark Brown <broonie@kernel.org> wrote:
>> > On Wed, Jan 08, 2014 at 05:22:18PM +0000, Laszlo Papp wrote:
>
>> >> - *             (eg, a clear on read interrupt status register). If this
>> >> + *             (e.g. a clear on read interrupt status register). If this
>
>> > This is somewhat outdated orthorgraphy...
>
>> Pardon ?
>
> It's not that common to write it as an abbreviation (even though it is
> one) and for some random reason you've decided to drop the comma which
> is standard.

Cannot agree. I see this effectively almost anywhere, and I even asked
this on IRC from native English speaker in #English @ freenode who
were in an agreement with me as far as I can tell.

That being said, I will not have time, nor the motivation to argue
over such a nuance, so feel free to reject the change.
