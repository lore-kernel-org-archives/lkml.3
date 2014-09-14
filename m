Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670AbaINNOg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 09:14:36 -0400
Received: from mout.gmx.net ([212.227.17.21]:51345 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594AbaINNOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 09:14:34 -0400
Message-ID: <5415948C.6080509@gmx.de>
Date: Sun, 14 Sep 2014 15:13:48 +0200
From: Hartmut Knaack <knaack.h@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:29.0) Gecko/20100101 Firefox/29.0 SeaMonkey/2.26.1
MIME-Version: 1.0
To: Jonathan Cameron <jic23@kernel.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        IIO <linux-iio@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        DEVICE TREE <devicetree@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>
CC: Carlo Caione <carlo@caione.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>, Alan Cox <alan@linux.intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
        Fugang Duan <B38611@freescale.com>, Arnd Bergmann <arnd@arndb.de>,
        Zubair Lutfullah <zubair.lutfullah@gmail.com>,
        Sebastian Reichel <sre@debian.org>,
        Johannes Thumshirn <johannes.thumshirn@men.de>,
        Philippe Reynes <tremyfr@yahoo.fr>,
        Angelo Compagnucci <angelo.compagnucci@gmail.com>,
        Doug Anderson <dianders@chromium.org>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH v3 5/5] iio: add documentation for current attribute
References: <1410477357-6407-1-git-send-email-jacob.jun.pan@linux.intel.com> <1410477357-6407-6-git-send-email-jacob.jun.pan@linux.intel.com> <5414A138.9080602@kernel.org>
In-Reply-To: <5414A138.9080602@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:NEuqBhvGp16QNgCfYn81gYyFjMB0S3GqEeEQ3C+gzfIMX8lt4sx
 JPnj6WHsyON6g3d/uKA1p42/tMuwWPqKe/RzKgIbYtj1kkvLsNt9U4fmDAtQYK6utBW2L4O
 ViLkIk+HB2VViOgNRpFTvUm5iu/Cc4G23xKvpDRuXhNvb1Q2ANcae1rPqFUnXUtf2hxHyk+
 aDqBO/q4wjXXBRXzT9vVw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Cameron schrieb, Am 13.09.2014 21:55:
> On 12/09/14 00:15, Jacob Pan wrote:
>> Add documentation for input current raw reading and scale.
>>
>> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> The content is fine, but please look at how the other types are handled.
> The raw attribute is described along with the units etc in it's own
> section, but the _scale attribute just gets lumped in with the equivalent
> for all the other channel types.
> 
> Thanks,
> 
> Jonathan
>> ---
>>  Documentation/ABI/testing/sysfs-bus-iio | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
>> index d760b02..3c76bd8 100644
>> --- a/Documentation/ABI/testing/sysfs-bus-iio
>> +++ b/Documentation/ABI/testing/sysfs-bus-iio
>> @@ -1028,3 +1028,11 @@ Contact:	linux-iio@vger.kernel.org
>>  Description:
>>  		Raw value of rotation from true/magnetic north measured with
>>  		or without compensation from tilt sensors.
>> +
>> +What:		/sys/bus/iio/devices/iio:deviceX/in_currentX_raw
>> +What:		/sys/bus/iio/devices/iio:deviceX/in_currentX_scale
>> +KernelVersion:	3.18
>> +Contact:	linux-iio@vger.kernel.org
>> +Description:
>> +		Raw current measurement from channel X. Units after application of
>> +		scale and offset are milliamps.
Where is the offset?
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

