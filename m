Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079AbaH3UJ5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 16:09:57 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:35930 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbaH3UJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 16:09:56 -0400
Message-ID: <54022F91.1090303@kernel.org>
Date: Sat, 30 Aug 2014 21:09:53 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Daniel Baluta <daniel.baluta@intel.com>
CC: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>,
        swarren@nvidia.com, Peter Meerwald <pmeerw@pmeerw.net>,
        linux-iio@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] iio: accel: kxcjk-1013: add support for kxcj9-1008
References: <1408461959-29660-1-git-send-email-daniel.baluta@intel.com> <CAEnQRZBHKbnKPe7raezXNzHovepRW4eJ4D33ZqVZMxP5o51PMQ@mail.gmail.com>
In-Reply-To: <CAEnQRZBHKbnKPe7raezXNzHovepRW4eJ4D33ZqVZMxP5o51PMQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/08/14 12:44, Daniel Baluta wrote:
> On Tue, Aug 19, 2014 at 6:25 PM, Daniel Baluta <daniel.baluta@intel.com> wrote:
>> This patch adds support for KXCJ9-1008 3-axis acceleromenter sensor.
>> KXCJ9-1008 uses the same register definitions as KXCJK-1013.
>>
>> The specification for KXCJ9-1008 can be downloaded from:
>> http://www.kionix.com/sites/default/files/KXCJ9-1008%20Specifications%20Rev%205.pdf
>>
>> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
> 
> Hi Jonathan,
> 
> Any comments on this?
Sorry, I was just being slow!

Anyhow, applied to the togreg branch of iio.git - initially pushed out as testing
for the autobuilders to play.
> 
> On Monday I will send a patch that adds support  KXTJ2-1009 and its
> based on this patch.
> I can squash them together if you want.
A separate patch would be great - I'm guessing htis one is a little more involved!

Jonathan
> 
> Daniel.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
