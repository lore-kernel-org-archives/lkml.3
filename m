Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537AbaH3Kpe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 06:45:34 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:59466 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbaH3Kpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 06:45:32 -0400
MIME-Version: 1.0
In-Reply-To: <5401A0A6.9010200@kernel.org>
References: <1408699042-17336-1-git-send-email-daniel.baluta@intel.com>
	<53FD9B88.5070901@gmx.de>
	<5401A0A6.9010200@kernel.org>
Date: Sat, 30 Aug 2014 13:45:30 +0300
X-Google-Sender-Auth: 7LDExlxb6LM1zB3SpfDLY0ezwg0
Message-ID: <CAEnQRZAO1Zj5qX48A0ao_peiggE11WQJGYxcGmn6quZ-9O0P2w@mail.gmail.com>
Subject: Re: [PATCH v3] iio: Add Dyna-Image AL3320A ambient light sensor driver
From: Daniel Baluta <daniel.baluta@intel.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Hartmut Knaack <knaack.h@gmx.de>, Daniel Baluta <daniel.baluta@intel.com>,
        linux-iio@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tsechih_Lin@asus.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2014 at 1:00 PM, Jonathan Cameron <jic23@kernel.org> wrote:
> On 27/08/14 09:49, Hartmut Knaack wrote:
>> Daniel Baluta schrieb:
>>> Minimal implementation. This driver provides raw illuminance readings.
>>>
>>> This is based on drivers/hwmon/al3320.c (*) driver from msm tree written
>>> by Tsechih Lin <Tsechih_Lin@asus.com>
>>>
>>> * https://android.googlesource.com/kernel/msm.git
>>>
>>> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
>> Hi, I think you should protect your write_raw with a mutex.
> Either that or drop the local store of the value and read it back from
> the device (assuming you can!).  That way everything becomes nice an
> atomic.  It's a rather narrow race, but Hartmut is correct in pointing it
> out.
>
> Few comments inline, mostly about my pet peeve: wrapper functions that don't
> do much.  Note I'm not that fussed if you really really want to keep them ;)
>
> Otherwise, looks good.
>

Thanks a lot for review Hartmut, Jonathan!

I will send v3 on Monday after I will re-test the changes.

Daniel.
