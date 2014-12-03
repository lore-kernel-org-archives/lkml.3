Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503AbaLCFSi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 00:18:38 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:35994 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbaLCFSg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 00:18:36 -0500
MIME-Version: 1.0
In-Reply-To: <547E616C.1020503@rock-chips.com>
References: <1417531766-29669-1-git-send-email-jay.xu@rock-chips.com>
	<1417531977-30094-1-git-send-email-jay.xu@rock-chips.com>
	<CAD=FV=Uwb1NxxCoXHzHu6DJCpnG_HV2RhCr3JaJaXbJja8kd7A@mail.gmail.com>
	<547E616C.1020503@rock-chips.com>
Date: Tue, 2 Dec 2014 21:18:35 -0800
X-Google-Sender-Auth: RKOzkqsQ0A1Lh_4TzIYMriJF-hY
Message-ID: <CAD=FV=VtYU5Pdz-xvjSdsReyCqMQaMtw=ZXmH4PO5wFnGVPY1g@mail.gmail.com>
Subject: Re: [PATCH 2/2] ASoC: rockchip: i2s: add support for grabbing output
 clock to codec
From: Doug Anderson <dianders@chromium.org>
To: Jianqun <xjq@rock-chips.com>
Cc: Jianqun Xu <jay.xu@rock-chips.com>, Liam Girdwood <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>, perex@perex.cz,
        tiwai@suse.de, Sonny Rao <sonnyrao@chromium.org>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        alsa-devel@alsa-project.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 2, 2014 at 5:03 PM, Jianqun <xjq@rock-chips.com> wrote:
> Hi Doug:
>
> 在 12/03/2014 01:54 AM, Doug Anderson 写道:
>> Jianqun,
>>
>> This ought to be a "v3" patch and ideally ought to describe
>> differences from v2 (after the cut).  Please have Kever or Chris
>> review your next patch before sending it out since I think they are
>> familiar with the process.

You still seem to be missing versions in your subject line and missing
info on what changed version to version.  The latest version you just
sent (v4?) is still missing it.

Unless Mark says so then I don't think you need to spin this series,
but please try to add that in the future.


>> You still forgot the blank line here requested by Heiko.  Please try
>> again.  See <https://patchwork.kernel.org/patch/5334991/>
> Although I thought there needn't a blank ~, I wll add it next patch

That would have been OK, but in that case you should have responded to
Heiko's patch and explained that you weren't taking his feedback (and
why you weren't).

-Doug
