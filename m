Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbaK0Drc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 22:47:32 -0500
Received: from mail-qg0-f52.google.com ([209.85.192.52]:37207 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367AbaK0Drb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 22:47:31 -0500
MIME-Version: 1.0
In-Reply-To: <3863623.tcGxuFQcZa@diego>
References: <1416381319-31117-1-git-send-email-sonnyrao@chromium.org> <3863623.tcGxuFQcZa@diego>
From: Sonny Rao <sonnyrao@chromium.org>
Date: Wed, 26 Nov 2014 19:47:10 -0800
X-Google-Sender-Auth: 8amZTZscjbX--mTC36efqDiZDZ0
Message-ID: <CAPz6YkXOS08hv7x+DM3roTuZYMbh9n4=kpTrH8NGYUffczQwLA@mail.gmail.com>
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

On Wed, Nov 26, 2014 at 3:32 PM, Heiko Stübner <heiko@sntech.de> wrote:
> Am Dienstag, 18. November 2014, 23:15:19 schrieb Sonny Rao:
>> This exposes the clock that comes out of the i2s block which generally
>> goes to the audio codec.
>>
>> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
>
> applied to my clk branch after removing the CLK_SET_RATE_PARENT

Hi, sorry for the delay, and thanks for fixing it.  I think when I
applied the patch to next-20141118 that had a CLK_SET_RATE_PARENT in
it from this patch:

commit fc69ed70c16a31d6a77ec47a30a9fe941f763f1e
Author: Jianqun <jay.xu@rock-chips.com>
Date:   Tue Sep 30 11:12:04 2014 +0800

    clk: rockchip: rk3288: i2s_frac adds flag to set parent's rate


I agree that is is not necessary and maybe not desirable.  Thanks again!


> Heiko
