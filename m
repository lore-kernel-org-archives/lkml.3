Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084Ab3HMNzP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 09:55:15 -0400
Received: from iona.labri.fr ([147.210.8.143]:47820 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757445Ab3HMNzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 09:55:13 -0400
Message-ID: <520A3AD0.5000304@labri.fr>
Date: Tue, 13 Aug 2013 09:55:28 -0400
From: Martin Peres <martin.peres@labri.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>
CC: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: Re: nouveau: temperature on nv40 is unavailable since ad40d73ef533ab0ad16b4a1ab2f7870c1f8ab954
References: <1836330.fGgIDqPTNA@pali> <520A2E1F.2050307@labri.fr> <3393485.1SLDJRVlAS@pali> <520A357D.2060100@labri.fr> <3b367f03-0ab0-4b22-893e-3f03f16a496e@gmail.com>
In-Reply-To: <3b367f03-0ab0-4b22-893e-3f03f16a496e@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/08/2013 09:53, Pali Rohár wrote:
> On utorok, 13. augusta 2013 15:32:45 CEST, Martin Peres wrote:
>> On 13/08/2013 09:23, Pali Rohár wrote:
>>> On Tuesday 13 August 2013 09:01:19 Martin Peres wrote:
>>  ...
>> You can check the temperature by running nvidia-settings. If you can't
>> see the temperature in it, then nvidia doesn't support it on your 
>> card and
>> I'm not sure we should :s
>>
>> Thanks for the vbios you sent me in private. For the others, the reason
>> why he doesn't have temperature anymore is because his vbios lacks
>> sensor calibration values.
>>
>>
>
> In nvidia-settings tab "GPU 0 - (GeForce 6600 GT)" --> "Thermal 
> Settings" is:
>
> Thermal Sensor Information:
> ID: 0
> Target: GPU
> Provider: GPU Internal
> Temperature: 70 C (now)
>
> I looked in Windows program SpeedFan. It found Nvidia PCI card and 
> reported "GPU Temp" about 68-70 C. So it looks like both nvidia driver 
> and windows SpeedFan program reading same values.
>
Great, I'll cook you a patch in a bit and you'll see what the 
temperature is like. It won't be perfectly accurate but there is some 
kind of default for nvidia cards of this generation.
