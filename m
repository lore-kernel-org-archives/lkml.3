Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374AbaEaKPR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 06:15:17 -0400
Received: from mail.kernel.org ([198.145.19.201]:45968 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753785AbaEaKPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 06:15:15 -0400
Message-ID: <5389AC1E.9000608@kernel.org>
Date: Sat, 31 May 2014 11:17:02 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Reyad Attiyat <reyad.attiyat@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org
Subject: Re: [PATCH] IIO: Support for True/Magnetic north
References: <538076CA.6050809@kernel.org> <1401160821-5006-1-git-send-email-reyad.attiyat@gmail.com> <5384B099.2070808@linux.intel.com>
In-Reply-To: <5384B099.2070808@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/05/14 16:34, Srinivas Pandruvada wrote:
> Hi Reyad,
>
> On 05/26/2014 08:20 PM, Reyad Attiyat wrote:
>> Hey Jonathan and Srinivas,
>>
>> I have added in the needed magn_north iio sysfs attributes to the documentation.
>> I hope I did everything correct.
>> I noticed that the line length was very long as compensated is a  fairly long word.
>> I'm thinking I could shorten some of the sysfs paths or shorten the name.
>>
>> For updating the hid-sensor-magn-3d do you have any tips on this? I'm thinking I'll need a
>> dynamic iio_chan array that is passed to iio_register function. It would need to
>> be dynamic in the sense it would only add channels if it found x, y, z, or one of
>> the north attributes. I'll start working on this soon.
>
> I think you mean dynamic " iio_chan_spec magn_3d_channels[]". Currently this is a
> constant. So we can change this to add only channel, which are available.
>
> Also your other changes must be submitted as series of patches, including the drivers using them.
I specifically requested that Reyad get the proposal out asap so that we could discuss it
'before' the patch series using it.  Obviously it won't get merged until there is
a driver using this interface, but often the interface discussion takes longer
than the review of the code so best to get it going asap!
>
> Thanks,
> Srinivas
>
>> Thank You,
>> Reyad Attiyat
>>
>>
>>
>> Reyad Attiyat (1):
>>    IIO: Added iio magn_north ABI documentation
>>
>>   Documentation/ABI/testing/sysfs-bus-iio | 76 +++++++++++++++++++++++++++++++++
>>   1 file changed, 76 insertions(+)
>>
>

