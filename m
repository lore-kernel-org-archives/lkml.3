Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824AbaBNHDa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 02:03:30 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:58320 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbaBNHD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 02:03:29 -0500
MIME-Version: 1.0
In-Reply-To: <20140213124002.GA3403@lee--X1>
References: <1392281438-31836-1-git-send-email-lpapp@kde.org>
	<20140213095817.GD32508@lee--X1>
	<20140213111530.2a2b4982@endymion.delvare>
	<CAOMwXhML8LvDCzmk1ZVT+7cARj9C3VtxERWBgOPM9vTc6qQXZQ@mail.gmail.com>
	<CAOMwXhOv-as1W69wcSno49jEXsXWZZ7odnu8og-vgnDwRTJ4sA@mail.gmail.com>
	<20140213113313.GL32508@lee--X1>
	<CAOMwXhMNHqXnzR0YHF9rx710JbaL3YFn=3cLf_WdNkCx7hbZug@mail.gmail.com>
	<20140213124002.GA3403@lee--X1>
Date: Fri, 14 Feb 2014 07:03:28 +0000
X-Google-Sender-Auth: e4ao23iAKKgr8b7lkEgOmRb75hk
Message-ID: <CAOMwXhPwppZ6Ne4TjR9Ys+ttST2r85j1GsLdxfq67svZSuVHFg@mail.gmail.com>
Subject: Re: [lm-sensors] [RFC PATCH] hwmon: (max6650) Convert to be a
 platform driver
From: Laszlo Papp <lpapp@kde.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Jean Delvare <jdelvare@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        lm-sensors@lm-sensors.org, Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 12:40 PM, Lee Jones <lee.jones@linaro.org> wrote:
>> http://comments.gmane.org/gmane.linux.kernel/1645251
>>
>> Step 2 did not happen. I did not get any review for my change. I
>> literally submitted that within a couple of hours after the request.
>>
>> Could you please tell me what was wrong with that change, and why I
>> did not get any respect not to "xargs rm -rf" my work in that area? I
>> believe I was ignored instead of improving the change, and someone
>> else tried to address the same thing. There was no argument in that
>> thread. It was a technical change. I personally do not feel happy
>> about it.
>
> Let's start again.
>
> Rebase your work on top of the HWMON tree on kernel.org and resubmit
> the entire set. If rebasing takes you more than 20 mins, you're
> probably doing it wrong.

I tried, but I could not manage it within 20 minutes, so I guess I am
doing something wrong. Can you please provide some pointers how not to
do it wrong? Perhaps, I am not aware of some tricks.
