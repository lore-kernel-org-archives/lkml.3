Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670AbaKCKbr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 05:31:47 -0500
Received: from smtp-out-246.synserver.de ([212.40.185.246]:1053 "EHLO
	smtp-out-246.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaKCKbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 05:31:43 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 25928
Message-ID: <5457598B.1050408@metafoo.de>
Date: Mon, 03 Nov 2014 11:31:39 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>, Jonathan Cameron <jic23@kernel.org>
CC: Hartmut Knaack <knaack.h@gmx.de>, Peter Meerwald <pmeerw@pmeerw.net>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v2] iio: inkern: Add of_xlate function to struct iio_info
References: <1413991783-24562-1-git-send-email-iivanov@mm-sol.com>	 <5447CDFA.5030407@metafoo.de> <544B75B8.1010505@kernel.org> <1415009224.407.13.camel@mm-sol.com>
In-Reply-To: <1415009224.407.13.camel@mm-sol.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2014 11:07 AM, Ivan T. Ivanov wrote:
>
> On Sat, 2014-10-25 at 11:04 +0100, Jonathan Cameron wrote:
>> On 22/10/14 16:32, Lars-Peter Clausen wrote:
>>> On 10/22/2014 05:29 PM, Ivan T. Ivanov wrote:
>>>> When #iio-cells is greater than '0', the driver could provide
>>>> a custom of_xlate function that reads the *args* and returns
>>>> the appropriate index in registered IIO channels array.
>>>>
>>>> Add simple translation function, suitable for the most 1:1
>>>> mapped channels in IIO chips, and use it when driver did not
>>>> provide custom implementation.
>>>>
>>>> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
>>>
>>> Reviewed-by: Lars-Peter Clausen <lars@metafoo.de>
>>>
>> Applied to the togreg branch of iio.git - initially pushed out as testing
>> for the autobuilders to play with it.
>
> Thank you. Probably my git skills failed me, but I can not
> find it in aforementioned branches. Is it publicly pushed?

It's in the testing branch.

http://git.kernel.org/cgit/linux/kernel/git/jic23/iio.git/log/?h=testing

