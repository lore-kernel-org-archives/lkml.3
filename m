Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751252AbaJYSVG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 14:21:06 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:49646 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbaJYSVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 14:21:02 -0400
Message-ID: <544B75B8.1010505@kernel.org>
Date: Sat, 25 Oct 2014 11:04:40 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Hartmut Knaack <knaack.h@gmx.de>, Peter Meerwald <pmeerw@pmeerw.net>
CC: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v2] iio: inkern: Add of_xlate function to struct iio_info
References: <1413991783-24562-1-git-send-email-iivanov@mm-sol.com> <5447CDFA.5030407@metafoo.de>
In-Reply-To: <5447CDFA.5030407@metafoo.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/10/14 16:32, Lars-Peter Clausen wrote:
> On 10/22/2014 05:29 PM, Ivan T. Ivanov wrote:
>> When #iio-cells is greater than '0', the driver could provide
>> a custom of_xlate function that reads the *args* and returns
>> the appropriate index in registered IIO channels array.
>>
>> Add simple translation function, suitable for the most 1:1
>> mapped channels in IIO chips, and use it when driver did not
>> provide custom implementation.
>>
>> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> 
> Reviewed-by: Lars-Peter Clausen <lars@metafoo.de>
> 
Applied to the togreg branch of iio.git - initially pushed out as testing
for the autobuilders to play with it.

Thanks,

Jonathan
