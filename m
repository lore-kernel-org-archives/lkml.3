Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756987AbbAZXC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 18:02:27 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:36693 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756624AbbAZXCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 18:02:23 -0500
MIME-Version: 1.0
In-Reply-To: <20150109173707.GB18076@amd>
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
 <1420816989-1808-2-git-send-email-j.anaszewski@samsung.com> <20150109173707.GB18076@amd>
From: Bryan Wu <cooloney@gmail.com>
Date: Mon, 26 Jan 2015 15:02:02 -0800
Message-ID: <CAK5ve-JV2EU+bT3yz4cMFLp0k-+Kk1YTQfEOV8cUCSvLUMuYng@mail.gmail.com>
Subject: Re: [PATCH/RFC v10 01/19] leds: Add LED Flash class extension to the
 LED subsystem
To: Pavel Machek <pavel@ucw.cz>
Cc: Jacek Anaszewski <j.anaszewski@samsung.com>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>, b.zolnierkie@samsung.com,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 9, 2015 at 9:37 AM, Pavel Machek <pavel@ucw.cz> wrote:
> On Fri 2015-01-09 16:22:51, Jacek Anaszewski wrote:
>> Some LED devices support two operation modes - torch and flash.
>> This patch provides support for flash LED devices in the LED subsystem
>> by introducing new sysfs attributes and kernel internal interface.
>> The attributes being introduced are: flash_brightness, flash_strobe,
>> flash_timeout, max_flash_timeout, max_flash_brightness, flash_fault,
>> flash_sync_strobe and available_sync_leds. All the flash related
>> features are placed in a separate module.
>>
>> The modifications aim to be compatible with V4L2 framework requirements
>> related to the flash devices management. The design assumes that V4L2
>> sub-device can take of the LED class device control and communicate
>> with it through the kernel internal interface. When V4L2 Flash sub-device
>> file is opened, the LED class device sysfs interface is made
>> unavailable.
>>
>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Bryan Wu <cooloney@gmail.com>
>> Cc: Richard Purdie <rpurdie@rpsys.net>
>
> Acked-by: Pavel Machek <pavel@ucw.cz>
>

Applied to my tree. Thanks for pushing this.

-Bryan
