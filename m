Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099Ab3HMNcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 09:32:33 -0400
Received: from iona.labri.fr ([147.210.8.143]:47445 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758037Ab3HMNcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 09:32:31 -0400
Message-ID: <520A357D.2060100@labri.fr>
Date: Tue, 13 Aug 2013 09:32:45 -0400
From: Martin Peres <martin.peres@labri.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>
CC: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: Re: nouveau: temperature on nv40 is unavailable since ad40d73ef533ab0ad16b4a1ab2f7870c1f8ab954
References: <1836330.fGgIDqPTNA@pali> <520A2E1F.2050307@labri.fr> <3393485.1SLDJRVlAS@pali>
In-Reply-To: <3393485.1SLDJRVlAS@pali>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/08/2013 09:23, Pali Rohár wrote:
> On Tuesday 13 August 2013 09:01:19 Martin Peres wrote:
>> On 13/08/2013 05:56, Pali Rohár wrote:
>>> Hello,
>>>
>>> after commit ad40d73ef533ab0ad16b4a1ab2f7870c1f8ab954 temperature
>>> information from lm sensors is not available on my Nvidia 6600GT graphics
>>> card. There is no nouveau hwmon entry in sysfs anymore. Why it was
>>> removed? Can I help with debugging? I'd like to see temperature sensor
>>> working again.
>> Hi,
>>
>> Thanks for bisecting the issue. Can you send me your vbios and tell
>> me if the nvidia driver shows your temperature probe (and what is
>> its source).
>>
>> To fetch your vbios, you can extract it using nvagetbios from the
>> envytools repo: https://github.com/envytools/envytools
>>
>> Cheers,
>> Martin
> How can I check source and temperature probe in nvidia binary driver?
You can check the temperature by running nvidia-settings. If you can't
see the temperature in it, then nvidia doesn't support it on your card and
I'm not sure we should :s

Thanks for the vbios you sent me in private. For the others, the reason
why he doesn't have temperature anymore is because his vbios lacks
sensor calibration values.
