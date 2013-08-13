Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073Ab3HMNxO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 09:53:14 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:33639 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758036Ab3HMNxN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 09:53:13 -0400
From: =?iso-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>
To: Martin Peres <martin.peres@labri.fr>
Cc: David Airlie <airlied@linux.ie>, <dri-devel@lists.freedesktop.org>,
        <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: Re: nouveau: temperature on nv40 is unavailable since =?iso-8859-1?Q?ad40d73ef533ab0ad16b4a1ab2f7870c1f8ab954?=
Date: Tue, 13 Aug 2013 15:53:10 +0200
User-Agent: trojita/v0.3.93-365-g54deea2; Qt/4.8.2; X11; Linux; Ubuntu 12.04.2 LTS
MIME-Version: 1.0
Message-ID: <3b367f03-0ab0-4b22-893e-3f03f16a496e@gmail.com>
In-Reply-To: <520A357D.2060100@labri.fr>
References: <1836330.fGgIDqPTNA@pali> <520A2E1F.2050307@labri.fr>
 <3393485.1SLDJRVlAS@pali> <520A357D.2060100@labri.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On utorok, 13. augusta 2013 15:32:45 CEST, Martin Peres wrote:
> On 13/08/2013 09:23, Pali Rohár wrote:
>> On Tuesday 13 August 2013 09:01:19 Martin Peres wrote:
>  ...
> You can check the temperature by running nvidia-settings. If you can't
> see the temperature in it, then nvidia doesn't support it on your card and
> I'm not sure we should :s
>
> Thanks for the vbios you sent me in private. For the others, the reason
> why he doesn't have temperature anymore is because his vbios lacks
> sensor calibration values.
>
>

In nvidia-settings tab "GPU 0 - (GeForce 6600 GT)" --> "Thermal Settings" is:

Thermal Sensor Information:
ID: 0
Target: GPU
Provider: GPU Internal
Temperature: 70 C (now)

I looked in Windows program SpeedFan. It found Nvidia PCI card and reported "GPU Temp" about 68-70 C. So it looks like both nvidia driver and windows SpeedFan program reading same values.

-- 
Pali Rohár
pali.rohar@gmail.com

