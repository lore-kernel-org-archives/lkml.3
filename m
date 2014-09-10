Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbaIJTgH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 15:36:07 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:49987 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbaIJTgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 15:36:04 -0400
MIME-Version: 1.0
In-Reply-To: <5410A652.8070006@kernel.org>
References: <1410332226-5481-1-git-send-email-daniel.baluta@intel.com>
	<54109112.90508@gmx.de>
	<5410A652.8070006@kernel.org>
Date: Wed, 10 Sep 2014 22:36:02 +0300
X-Google-Sender-Auth: R73LtHB3opAn10YXWBCxosOl-Ro
Message-ID: <CAEnQRZAu5X6j4HG8_hbrx8ZSKqYcdQCg=SodX63jvM_71_USrQ@mail.gmail.com>
Subject: Re: [PATCH v7] iio: Add Dyna-Image AL3320A ambient light sensor driver
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

On Wed, Sep 10, 2014 at 10:28 PM, Jonathan Cameron <jic23@kernel.org> wrote:
> On 10/09/14 18:57, Hartmut Knaack wrote:
>> Daniel Baluta schrieb, Am 10.09.2014 08:57:
>>> Minimal implementation. This driver provides raw illuminance readings.
>>>
>>> This is based on drivers/hwmon/al3320.c (*) driver from msm tree written
>>> by Tsechih Lin <Tsechih_Lin@asus.com>
>>>
>>> * https://android.googlesource.com/kernel/msm.git
>>>
>>> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
>> Reviewed-by: Hartmut Knaack <knaack.h@gmx.de>
> Thanks Daniel.
> Also thanks to Hartmut for reviewing stamina.
>
> I've been effectively offline for a 10 days (some of it spent in a fridge)
> so am even more grateful to those who help with reviewing than normal.
>
> Applied to the togreg branch of iio.git which I will push out as testing
> for the autobuilders to play when not in an airport departure lounge on the
> 30 mins of free airport wifi.  What fun.
>
> I wonder if this will send?

Well, it's here ;). Have a nice flight!

thanks,
Daniel.
