Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751177AbaDPQ2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 12:28:32 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:50098 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbaDPQ2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 12:28:30 -0400
MIME-Version: 1.0
In-Reply-To: <20140415211832.GA32213@amd.pavel.ucw.cz>
References: <1395348795-8554-1-git-send-email-sebastian.capella@linaro.org>
	<1395348795-8554-2-git-send-email-sebastian.capella@linaro.org>
	<20140320212336.GA17368@amd.pavel.ucw.cz>
	<20140320213502.795a5d3c@alan.etchedpixels.co.uk>
	<CADHgK6uXg0CXZC5s5Z5Kpy6dYH58UChL-p9ozCCcoUU=-0KJYw@mail.gmail.com>
	<CADHgK6sh6TUc4jBQFQHTQuhze9=r2FBzF6aULUc_c+bbWYjp5w@mail.gmail.com>
	<CADHgK6sCmPVZ--eyEnqnjfs_4C_PfHTgAUQ_Nb4oJP0mBDnQUw@mail.gmail.com>
	<20140415205453.GX24070@n2100.arm.linux.org.uk>
	<20140415211832.GA32213@amd.pavel.ucw.cz>
Date: Wed, 16 Apr 2014 09:28:28 -0700
Message-ID: <CADHgK6vzagyELYGnVoHvfnK9G57-NSycOaKsNQ53rnU1pOwn=Q@mail.gmail.com>
Subject: Re: [PATCH RFC] PM / Hibernate: no kernel_power_off when pm_power_off NULL
From: Sebastian Capella <sebastian.capella@linaro.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 April 2014 14:18, Pavel Machek <pavel@ucw.cz> wrote:
> On Tue 2014-04-15 21:54:53, Russell King - ARM Linux wrote:
>> What I'm basically saying is that I see no reason for ARM to do something
>> different to what x86 does.
>>
>> What is pretty clear to me is that ARM is compatible with x86, which is
>> compatible with kernel/reboot.c, and it's the hibernate code which is
>> the odd one out.
>
> I'm pretty sure the original code did not return. Anyway, the best
> solution, given how many platforms are out there, would be to
>
> a) document that it should not return
>
> b) fix hibernation to handle the returning case, anyway.

Thanks Russell and Pavel!

This sounds fine to me.  Any objections?

Thanks!

Sebastian
