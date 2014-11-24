Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585AbaKXCI2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 21:08:28 -0500
Received: from mail-qg0-f42.google.com ([209.85.192.42]:65404 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbaKXCI0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 21:08:26 -0500
MIME-Version: 1.0
In-Reply-To: <2905614.GvjeQFvyvc@diego>
References: <1416381319-31117-1-git-send-email-sonnyrao@chromium.org> <2905614.GvjeQFvyvc@diego>
From: Sonny Rao <sonnyrao@chromium.org>
Date: Sun, 23 Nov 2014 18:08:05 -0800
X-Google-Sender-Auth: j1f6r0_4iKmu9jgBvLPIf9MK28g
Message-ID: <CAPz6YkXSdTode-eu=HuMR1H8x9APi=xOQA+_4D6K4yXEThLQ5g@mail.gmail.com>
Subject: Re: [PATCH] clk: rockchip: rk3288 export i2s0_clkout for use in DT
To: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-rockchip@lists.infradead.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Douglas Anderson <dianders@chromium.org>,
        Mike Turquette <mturquette@linaro.org>,
        Mark yao <mark.yao@rock-chips.com>,
        Kever Yang <kever.yang@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2014 at 4:07 PM, Heiko Stübner <heiko@sntech.de> wrote:
> Hi Sonny,
>
> Am Dienstag, 18. November 2014, 23:15:19 schrieb Sonny Rao:
>> This exposes the clock that comes out of the i2s block which generally
>> goes to the audio codec.
>>
>> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
>> ---
>>  drivers/clk/rockchip/clk-rk3288.c      | 3 ++-
>>  include/dt-bindings/clock/rk3288-cru.h | 1 +
>>  2 files changed, 3 insertions(+), 1 deletion(-)
>>
>
> [...]
>
>> diff --git a/include/dt-bindings/clock/rk3288-cru.h
>> b/include/dt-bindings/clock/rk3288-cru.h index 100a08c..4acc730 100644
>> --- a/include/dt-bindings/clock/rk3288-cru.h
>> +++ b/include/dt-bindings/clock/rk3288-cru.h
>> @@ -71,6 +71,7 @@
>>  #define SCLK_HDMI_CEC                110
>>  #define SCLK_HEVC_CABAC              111
>>  #define SCLK_HEVC_CORE               112
>> +#define SCLK_I2S0_OUT           113
>>
>>  #define DCLK_VOP0            190
>>  #define DCLK_VOP1            191
>
> just to get branches right, do you plan on sending a patch using this new
> clock-id in a devicetree file in time for 3.19 (i.e. during the next week).
>
> If you plan on doing this, we'll need a 2-patch series like Alexandru did for
> the mmc phases [because we would need a shared branch between clk and dts
> branches]. If not the patch can stay as it is.
>

Hi, I'm not planning on sending anything with this new clock in the
immediate future, so I think you can take it as is.  Eventually, we
will submit something that uses it for the audio codec on Pinky using
simple-card but I don't have that ready yet.  Thanks!

> Thanks
> Heiko
