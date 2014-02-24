Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbaBXWsa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 17:48:30 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:37350 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbaBXWs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 17:48:28 -0500
MIME-Version: 1.0
In-Reply-To: <5305C13D.7040907@linaro.org>
References: <1392670532-21523-1-git-send-email-wsa@the-dreams.de>
	<5305C13D.7040907@linaro.org>
Date: Tue, 25 Feb 2014 07:48:26 +0900
Message-ID: <CANqRtoT6+6no5fT-6o7jD9k0hF+mMvU4z0ZmUCLksOsJTS0X8Q@mail.gmail.com>
Subject: Re: [PATCH V6 0/3] clocksource: Consolidate SH and ARM mach-shmobile
 Kconfig bits
From: Magnus Damm <magnus.damm@gmail.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Wolfram Sang <wsa@the-dreams.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        SH-Linux <linux-sh@vger.kernel.org>,
        "Simon Horman [Horms]" <horms@verge.net.au>,
        John Stultz <john.stultz@linaro.org>, Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 5:47 PM, Daniel Lezcano
<daniel.lezcano@linaro.org> wrote:
> On 02/17/2014 09:55 PM, Wolfram Sang wrote:
>>
>> This is V6 of the SH and ARM mach-shmobile clocksource Kconfig
>> consolidation
>> series. It is a rebased version of V5 (which did not get any comments) on
>> top
>> of the latest renesas/devel tag. This series is not just an optimization,
>> it
>> also makes it possible to enable the clocksource for the r7s72100
>> platform.
>> Without it, the current kernel is hardly usable for these devices at the
>> moment
>> (broken userland). So, it would be nice to have the series in 3.15. For
>> more
>> details, I quote the cover-letter from Magnus for V5 at the end. I
>> successfully
>> tested the patches on r7s72100 and r8a7791 platforms. The branch can be
>> found
>> here:
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git
>> renesas/rework-clock-configs
>
>
> Hi Wolfram,
>
> actually I was waiting for Magnus to send me the patchset respinned against
> timers/core [1].

Hi Daniel,

Thanks for your help and my apologies for this confusion. I moved
house during December and a couple of things got dropped including
this one.

> So if you mind, please refresh the series against timers/core as this series
> does not apply for my tree.

I noticed that Wolfram picked it up, thanks to both of you - I
appreciate your help!

Cheers,

/ magnus
