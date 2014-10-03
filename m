Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758831AbaJCWo7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:44:59 -0400
Received: from webmail.tpnet.fi ([62.106.63.33]:35923 "EHLO webmail.tpnet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756909AbaJCWo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:44:56 -0400
X-Greylist: delayed 593 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Oct 2014 18:44:55 EDT
Message-ID: <542F2493.2020805@iki.fi>
Date: Sat, 04 Oct 2014 01:34:59 +0300
From: Anssi Hannula <anssi.hannula@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Jonathan Cameron <jic23@kernel.org>
CC: Lars-Peter Clausen <lars@metafoo.de>,
        Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: iio commit dates in future (was: Re: [PATCH] iio: adc: xilinx-xadc:
 assign auxiliary channels address correctly)
References: <344d9464-c489-42cd-b9c4-a63759f8f6da@BL2FFO11FD040.protection.gbl> <54132C78.9000300@metafoo.de> <5414A36B.3000106@kernel.org>
In-Reply-To: <5414A36B.3000106@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

13.09.2014, 23:04, Jonathan Cameron kirjoitti:
> On 12/09/14 18:25, Lars-Peter Clausen wrote:
>> On 09/11/2014 10:55 AM, Subbaraya Sundeep Bhatta wrote:
>>> This patch fixes incorrect logic for assigning address
>>> to auxiliary channels of xilinx xadc.
>>>
>>> Signed-off-by: Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
>>
>> Acked-by: Lars-Peter Clausen <lars@metafoo.de>
> Applied to the fixes-togreg branch of iio.git and flagged
> for stable.

Something weird seems to have happened with this commit and at least a
few others:
1887e724e2 "iio: adc: xilinx-xadc: assign auxiliary channels address
correctly"
d4f51956ac "iio: adc: at91: don't use the last converted data register"
a31d092899 "iio:magnetometer: bugfix magnetometers gain values".

They all have their Date in the future (up to Nov 2014), looks to me
like month and day got swapped for some reason.

Not a big issue I guess, but worth looking into if it is something in
your workflow causing this :)

Noticed these strange Dates while looking at Greg's stable-queue repo.

-- 
Anssi Hannula
