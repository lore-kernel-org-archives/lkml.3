Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536AbaIJEpZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 00:45:25 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:59583 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbaIJEpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 00:45:23 -0400
MIME-Version: 1.0
In-Reply-To: <CAD=FV=U+5mHxyT0E6u8wt2qdZVhsB-K_NKprQvRu7XUeh=iCSg@mail.gmail.com>
References: <1408460913-13863-1-git-send-email-javier.martinez@collabora.co.uk>
	<1408460913-13863-3-git-send-email-javier.martinez@collabora.co.uk>
	<CAD=FV=U+5mHxyT0E6u8wt2qdZVhsB-K_NKprQvRu7XUeh=iCSg@mail.gmail.com>
Date: Tue, 9 Sep 2014 21:45:22 -0700
X-Google-Sender-Auth: S39RhGxWBsMMnLcxADRV9-zrdIk
Message-ID: <CAD=FV=V+8-zDPu9MhrGV6eMwfb7nvqhCxBnMtDsduc-WUK2Rcg@mail.gmail.com>
Subject: Re: [PATCH 2/6] ARM: dts: add hdmi regulators for exynos5800 based
 peach-pi board
From: Doug Anderson <dianders@chromium.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Mark Brown <broonie@kernel.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Sep 9, 2014 at 9:44 PM, Doug Anderson <dianders@chromium.org> wrote:
> Javier / Rahul,
>
> On Tue, Aug 19, 2014 at 8:08 AM, Javier Martinez Canillas
> <javier.martinez@collabora.co.uk> wrote:
>> From: Rahul Sharma <rahul.sharma@samsung.com>
>>
>> Adding regulators for HDMI for Peach-pi board.
>>
>> Signed-off-by: Rahul Sharma <rahul.sharma@samsung.com>
>> Reviewed-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
>> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
>> ---
>>
>> v2: 1) Add blank line before hdmi regulators.
>>
>>  arch/arm/boot/dts/exynos5800-peach-pi.dts | 5 +++++
>>  1 file changed, 5 insertions(+)
>
> Reviewed-by: Doug Anderson <dianders@chromium.org>

Meant to add this to the v2.  Sorry for the spam...
