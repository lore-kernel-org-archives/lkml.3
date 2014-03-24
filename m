Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbaCXODf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 10:03:35 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37578 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752249AbaCXODc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 10:03:32 -0400
Message-ID: <53303B27.2040201@free-electrons.com>
Date: Mon, 24 Mar 2014 15:03:19 +0100
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Kevin Hilman <khilman@deeprootsystems.com>
CC: Wolfram Sang <wsa@the-dreams.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: [PATCH] i2c: mv64xxx: Fix compilation breakage
References: <1394204370-22979-1-git-send-email-maxime.ripard@free-electrons.com> <20140307160836.GM21483@n2100.arm.linux.org.uk> <20140310105808.GE2815@lukather> <20140310112929.GY21483@n2100.arm.linux.org.uk> <CAP=VYLqCmG6fRmPPABoW4xg_tFgGh2pji=f5ML=cBgCu4zZocg@mail.gmail.com> <20140321191739.GT27873@lukather> <20140324133349.GA2631@katana>
In-Reply-To: <20140324133349.GA2631@katana>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof, Kevin,

On 24/03/2014 14:33, Wolfram Sang wrote:
> 
>>> Looping linux-next into the CC since this is the cause of the failure
>>> in orion5x_defconfig there, and no point in anyone else re-doing the
>>> same bisect.
>>
>> I sent a fix for this that hasn't been picked up yet:
>> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-March/239069.html
>>
>> IIRC, Wolfram's away until Monday, so I guess it will be merged some
>> time next week.
> 
> I'd love to apply the fix but the reset framework update is not in
> linux-next yet.
> 

I saw the there was a pull request resent last week. Is there any
reason to not have pulled it, yet?
http://www.spinics.net/lists/arm-kernel/msg316518.html

I would really like that it was sorted out, because all the build using
the mvebu related defconfig fails since two weeks because of it now.

I am ready to help if you need it.

Thanks!


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
