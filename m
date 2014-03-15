Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000AbaCOQdI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 12:33:08 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:60784 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866AbaCOQdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 12:33:05 -0400
Message-ID: <532480FA.4010604@kernel.org>
Date: Sat, 15 Mar 2014 16:34:02 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Josh Wu <josh.wu@atmel.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [PATCH] iio: adc: at91_adc: correct default shtim value
References: <1393870024-20704-1-git-send-email-alexandre.belloni@free-electrons.com> <531704DA.5000200@atmel.com>
In-Reply-To: <531704DA.5000200@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/14 11:04, Josh Wu wrote:
> Hi, Alexandre
>
> On 3/4/2014 2:07 AM, Alexandre Belloni wrote:
>> When sample_hold_time is zero (this is the case when DT is not used or if
>> atmel,adc-sample-hold-time is omitted), then the calculated shtim is large.
>>
>> Make that 0, which is the default for that register and the ADC will then use a
>> sane value of 2/ADCCLK or 1/ADCCLK depending on the version.
>>
>> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
>
> Thanks for the fix and
>
> Acked-by: Josh Wu<josh.wu@atmel.com>
>
Applied to the fixes-togreg branch of iio.git.
Note that is likely that this will go upstream after the merge window now.

