Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbaGYPNM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:13:12 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:57939 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbaGYPNI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 11:13:08 -0400
MIME-Version: 1.0
In-Reply-To: <CAD=FV=VUkU7HWjwCKO=WOrKosUtmv3YE_8pxc5uoQg0cHr-AKQ@mail.gmail.com>
References: <1405704009-8430-1-git-send-email-afaerber@suse.de>
	<1405704009-8430-2-git-send-email-afaerber@suse.de>
	<08fe01cfa7c9$341cc700$9c565500$@samsung.com>
	<CAD=FV=VUkU7HWjwCKO=WOrKosUtmv3YE_8pxc5uoQg0cHr-AKQ@mail.gmail.com>
Date: Fri, 25 Jul 2014 08:13:07 -0700
X-Google-Sender-Auth: cchP7DokDSkxUeqIWUl51_L35og
Message-ID: <CAD=FV=VeBP=1CiKesp738anZzSJNZCGkg68RBUUCyJ5U6_Y75w@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] ARM: dts: exynos5250: max77686 is Snow only
From: Doug Anderson <dianders@chromium.org>
To: Kukjin Kim <kgene.kim@samsung.com>,
        =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Stephan van Schaik <stephan@synkhronix.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Ben Dooks <ben-linux@fluff.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "moderated list:ARM/SAMSUNG ARM A..." 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas,

On Fri, Jul 25, 2014 at 8:08 AM, Doug Anderson <dianders@chromium.org> wrote:
> Hi,
>
> On Thu, Jul 24, 2014 at 10:28 PM, Kukjin Kim <kgene.kim@samsung.com> wrote:
>> Andreas Färber wrote:
>>>
>>> Move it from exynos5250-cros-common.dtsi to exynos5250-snow.dts.
>>> Spring does not need it, it uses an s5m8767 instead.
>>>
>>> Signed-off-by: Andreas Färber <afaerber@suse.de>
>>> ---
>>
>> Hi Andreas,
>>
>> I think this should be reviewed by chrome guys.
>>
>>
>> Doug, can you have a look this series for exynos5250-chromebook?
>> I'm not sure exynos5250-cros-common is still useful for exynos5250-spring...
>
> Sorry, I've been on vacation and am now playing catchup.
>
> Right.  The current suggestion is to rework to just duplicate things
> and don't use exynos5250-cros-common.

Oh, it actually looks like your patch series ends up there, but the
first patch confused me.  Why move just the maxim PMIC first?  Move
everything at once and be done with the common file, then do
cleanup...
