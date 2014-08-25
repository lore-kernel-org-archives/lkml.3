Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbaHYII4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 04:08:56 -0400
Received: from smtp-out-248.synserver.de ([212.40.185.248]:1095 "EHLO
	smtp-out-247.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754673AbaHYIIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 04:08:52 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 5953
Message-ID: <53FAEF10.7010001@metafoo.de>
Date: Mon, 25 Aug 2014 10:08:48 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.7.0
MIME-Version: 1.0
To: "Sharma, Sanjeev" <Sanjeev_Sharma@mentor.com>,
        sanjeev sharma <sanjeevsharmaengg@gmail.com>
CC: "jic23@kernel.org" <jic23@kernel.org>, gregkh <gregkh@linuxfoundation.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging:iio: moved platform_data into include/linux/iio
References: <1408516869-6099-1-git-send-email-sanjeev_sharma@mentor.com>	<53F441FF.9090304@metafoo.de> <CAGUYZuSENkSjoA9U0E8MQKp0a1J3moE8p8NYAzfiZ+BpxND4Aw@mail.gmail.com> <53F4451B.3040209@metafoo.de> <FDC088D3B5555644AE135ED28A7ABDE94DF3CC4B@EU-MBX-04.mgc.mentorg.com>
In-Reply-To: <FDC088D3B5555644AE135ED28A7ABDE94DF3CC4B@EU-MBX-04.mgc.mentorg.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2014 09:17 AM, Sharma, Sanjeev wrote:
> Hello Lars,
>
> As per your suggestion Can I move complete Driver out of staging specially SPI ADC Driver.

Only if they are cleaned up first. All of the drivers that are still in 
staging do have issues, otherwise we'd already had moved them. A few of them 
are OK codestyle wise, but do have ABI issues which need to be resolved 
before they can be moved.

- Lars

>
> Regards
> Sanjeev Sharma
>
> -----Original Message-----
> From: Lars-Peter Clausen [mailto:lars@metafoo.de]
> Sent: Wednesday, August 20, 2014 12:20 PM
> To: sanjeev sharma
> Cc: Sharma, Sanjeev; jic23@kernel.org; gregkh; linux-iio@vger.kernel.org; devel; linux-kernel
> Subject: Re: [PATCH] staging:iio: moved platform_data into include/linux/iio
>
> On 08/20/2014 08:44 AM, sanjeev sharma wrote:
>> Hi,
>>
>> This was the action item(TO-DO). IMO, it make sense to move into
>> include/linux/iio because IIO complete subsystem may take some time.
>
> The code that is in staging is not supposed to 'leak' outside of staging. So either you move the driver as a whole out of staging or leave it there, but do not move individual files of the driver out of staging. The action item is for when the driver is moved out of staging.
>

