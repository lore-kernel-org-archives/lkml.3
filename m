Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188AbaCOO7U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 10:59:20 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:60134 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbaCOO7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 10:59:18 -0400
Message-ID: <53246B01.7050204@kernel.org>
Date: Sat, 15 Mar 2014 15:00:17 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Marek Vasut <marex@denx.de>, Matt Ranostay <mranostay@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        devicetree@vger.kernel.org, matt.porter@linaro.org,
        pantelis.antoniou@gmail.com
Subject: Re: [PATCH v8 2/2] iio: Add AS3935 lightning sensor support
References: <1394628794-7598-1-git-send-email-mranostay@gmail.com> <1394628794-7598-3-git-send-email-mranostay@gmail.com> <201403130309.32474.marex@denx.de>
In-Reply-To: <201403130309.32474.marex@denx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/03/14 02:09, Marek Vasut wrote:
> On Wednesday, March 12, 2014 at 01:53:14 PM, Matt Ranostay wrote:
>> AS3935 chipset can detect lightning strikes and reports those back as
>> events and the estimated distance to the storm.
>>
>> Signed-off-by: Matt Ranostay <mranostay@gmail.com>
>
> Reviewed-by: Marek Vasut <marex@denx.de>
I'm not 100% happy with sensor_sensitivity but don't have a better idea.
As it is device specific lets leave it be for now.   Should we come
up with a better idea later it isn't much extra code to keep supporting
this interface going forwards.

Applied to the togreg branch of iio.git (pushed out initially as testing)

Thanks,

Jonathan

