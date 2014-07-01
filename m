Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282AbaGAL7m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 07:59:42 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:37609 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbaGAL7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 07:59:40 -0400
Message-ID: <53B2A2A5.4070203@gmail.com>
Date: Tue, 01 Jul 2014 17:29:33 +0530
From: Tushar Behera <trblinux@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Kevin Hilman <khilman@linaro.org>
CC: Doug Anderson <dianders@google.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Kukjin Kim <kgene.kim@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Shaik Ameer Basha <shaik.ameer@samsung.com>
Subject: Re: [PATCH 2/3] ARM: dts: Update the parent for Audss clocks in Exynos5420
References: <1402464739-19044-1-git-send-email-tushar.b@samsung.com>	<1402464739-19044-3-git-send-email-tushar.b@samsung.com>	<CAD=FV=W5yh58fYTwRZxmZt=BORcZMSRV0oRe12yA74Q5h2S4YQ@mail.gmail.com>	<7hpphwlgn0.fsf@paris.lan>	<CAC5m3Bzey-YoPLmjAq4YNPQ13rojtVFWAbnhX6-ZFtYZwEdMWg@mail.gmail.com>	<7h8uojk61a.fsf@paris.lan>	<53ACE724.7090606@gmail.com>	<CAGa+x86COQz+cYtrXWrP-sjFGz-gi2tf6GEvLiKYoQwg1zMivQ@mail.gmail.com> <CAGa+x87LHiYGb03=GRcZisK1=TyakW1htd1E2vOQ6ijZKw8syg@mail.gmail.com>
In-Reply-To: <CAGa+x87LHiYGb03=GRcZisK1=TyakW1htd1E2vOQ6ijZKw8syg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2014 08:18 PM, Kevin Hilman wrote:
> On Fri, Jun 27, 2014 at 7:18 AM, Kevin Hilman <khilman@linaro.org> wrote:
>> On Thu, Jun 26, 2014 at 8:38 PM, Tushar Behera <trblinux@gmail.com> wrote:
>>
>>> Would you please provide me the environment setting of your u-boot?
>>> U-boot environment on my board has been over-written, I would like to
>>> set it same as yours and try to reproduce the issue at my end. With only
>>> 'sound init', I don't seem to hit this issue anymore.
>>
>> Attached is a full boot log using v3.16-rc2 with my patch adding
>> CLK_IGNORE_UNUSED to mau_epll and Doug's aclk66_peric patch.  In the
>> boot log, you'll see the output of 'printenv' inside u-boot where the
>> environment is dumped.
> 
> Oops, I sent you a boot log for the octa board.  Here's the one for
> peach-pi with the same kernel (built with upstream exynos_defconfig)
> 
> Kevin
> 

The u-boot version is a little different on my Peach-Pi as compared to
the market release version. Not sure if that is making any difference.

Peach # version

U-Boot 2013.04 (Feb 13 2014 - 16:35:03) for Peach
armv7a-cros-linux-gnueabi-gcc.real (4.8.1_cos_gg_feea904_4.8.1-r66)
4.8.x-google 20130905 (prerelease)
GNU ld (binutils-2.22_cos_gg_2) 2.22

-- 
Tushar Behera
