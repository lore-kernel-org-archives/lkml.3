Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278AbaJDKRZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 06:17:25 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:57345 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaJDKRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 06:17:22 -0400
Message-ID: <542FC92E.9040209@kernel.org>
Date: Sat, 04 Oct 2014 11:17:18 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Anssi Hannula <anssi.hannula@iki.fi>
CC: Lars-Peter Clausen <lars@metafoo.de>,
        Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: iio commit dates in future
References: <344d9464-c489-42cd-b9c4-a63759f8f6da@BL2FFO11FD040.protection.gbl> <54132C78.9000300@metafoo.de> <5414A36B.3000106@kernel.org> <542F2493.2020805@iki.fi>
In-Reply-To: <542F2493.2020805@iki.fi>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/14 23:34, Anssi Hannula wrote:
> 13.09.2014, 23:04, Jonathan Cameron kirjoitti:
>> On 12/09/14 18:25, Lars-Peter Clausen wrote:
>>> On 09/11/2014 10:55 AM, Subbaraya Sundeep Bhatta wrote:
>>>> This patch fixes incorrect logic for assigning address
>>>> to auxiliary channels of xilinx xadc.
>>>>
>>>> Signed-off-by: Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
>>>
>>> Acked-by: Lars-Peter Clausen <lars@metafoo.de>
>> Applied to the fixes-togreg branch of iio.git and flagged
>> for stable.
> 
> Something weird seems to have happened with this commit and at least a
> few others:
> 1887e724e2 "iio: adc: xilinx-xadc: assign auxiliary channels address
> correctly"
> d4f51956ac "iio: adc: at91: don't use the last converted data register"
> a31d092899 "iio:magnetometer: bugfix magnetometers gain values".
> 
> They all have their Date in the future (up to Nov 2014), looks to me
> like month and day got swapped for some reason.
> 
> Not a big issue I guess, but worth looking into if it is something in
> your workflow causing this :)
> 
> Noticed these strange Dates while looking at Greg's stable-queue repo.
> 
I have a suspicion that this is to do with the fact I use thunderbird to
manage my email and save it out as plain text.   I'm using the import
export tools package on top of thunderbird (as it gives a cleaner result)
but it is using numeric dates.  Which git am is happy with, but apparently
it isn't coping well with American date formats vs mine.  Superficially
looks like this is fine if I use the much more verbose alternative of
saving as an eml file and using that...

There are some dates that have by coincidence jumped a fair way back into
the past as well.

I did notice an incidence of this a few months back but thought it was just
a one off.  Thanks for bringing it up Anssi!

Jonathan


