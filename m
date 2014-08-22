Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695AbaHVBPQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 21:15:16 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:40343 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754985AbaHVBPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 21:15:14 -0400
MIME-Version: 1.0
In-Reply-To: <1408669991-9703-1-git-send-email-addy.ke@rock-chips.com>
References: <1408657107-8715-1-git-send-email-addy.ke@rock-chips.com>
	<1408669991-9703-1-git-send-email-addy.ke@rock-chips.com>
Date: Thu, 21 Aug 2014 18:15:13 -0700
X-Google-Sender-Auth: ThqqJYL2UGjx9T_L4lemqPCTQhw
Message-ID: <CAD=FV=XY73RU1B4i1NEBffiRTbwMO_0Z9+Lh96-sckQmkH8Ogg@mail.gmail.com>
Subject: Re: [PATCH v3] i2c: rk3x: fix bug that cause transfer fails in master
 receive mode
From: Doug Anderson <dianders@chromium.org>
To: Addy Ke <addy.ke@rock-chips.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, max.schwarz@online.de,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>, sergei.shtylyov@cogentembedded.com,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-rockchip@lists.infradead.org, Eddie Cai <cf@rock-chips.com>,
        Jianqun Xu <xjq@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Chris <zyw@rock-chips.com>,
        =?UTF-8?B?5aea5pm65oOF?= <yzq@rock-chips.com>,
        han jiang <hj@rock-chips.com>, Kever Yang <kever.yang@rock-chips.com>,
        Lin Huang <hl@rock-chips.com>,
        =?UTF-8?B?5pmT6IW+546L?= <caesar.wang@rock-chips.com>,
        Shunqian Zheng <zhengsq@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Addy,

On Thu, Aug 21, 2014 at 6:13 PM, Addy Ke <addy.ke@rock-chips.com> wrote:
> In rk3x SOC, the I2C controller can receive/transmit up to 32 bytes data
> in one chunk, so the size of data to be write/read to/from TXDATAx/RXDATAx
> must be less than or equal 32 bytes at a time.
>
> Tested on rk3288-pinky board, elan receive 158 bytes data.
>
> Acked-by: Max Schwarz <max.schwarz@online.de>
> Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
> ---
> Changes in v2:
> - Use cleaner syntax as suggested by Sergei.
> - Update commit message as suggested by Wolfram.
>
> Changes in v3:
> - fix typo: maste --> master and double spaces after 'len'
>
>  drivers/i2c/busses/i2c-rk3x.c | 4 ++++
>  1 file changed, 4 insertions(+)

Oops, we collided in the ether.  This looks good to me.

Tested-by: Doug Anderson <dianders@chromium.org>
