Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685AbaIYPLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 11:11:19 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:50285 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160AbaIYPLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 11:11:09 -0400
MIME-Version: 1.0
In-Reply-To: <1410513887-17459-1-git-send-email-mark.yao@rock-chips.com>
References: <1410513887-17459-1-git-send-email-mark.yao@rock-chips.com>
Date: Thu, 25 Sep 2014 08:11:07 -0700
X-Google-Sender-Auth: mnePN3bJ0eUEJo1nzhHKmSDkgKA
Message-ID: <CAD=FV=WafEa_aaFxYjrEbuJ-9CRwwpKzv66jKrg7G3GdxjGfNg@mail.gmail.com>
Subject: Re: [PATCH] clk: rockchip: rk3288: fix softreset register count
From: Doug Anderson <dianders@chromium.org>
To: Mark yao <mark.yao@rock-chips.com>, Mike Turquette <mturquette@linaro.org>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Kurtz <djkurtz@chromium.org>,
        =?UTF-8?B?5oi05YWL6ZyWIChKYWNrKQ==?= <dkl@rock-chips.com>,
        Eddie Cai <eddie.cai@rock-chips.com>, Jianqun Xu <xjq@rock-chips.com>,
        =?UTF-8?B?5p+v6aOe6ZuE?= <kfx@rock-chips.com>,
        Tao Huang <huangtao@rock-chips.com>, Chris <zyw@rock-chips.com>,
        =?UTF-8?B?6Zer5a2d5Yab?= <yxj@rock-chips.com>,
        jeff chen <cym@rock-chips.com>,
        Shunqian Zheng <zhengsq@rock-chips.com>,
        =?UTF-8?B?5pmT6IW+546L?= <caesar.wang@rock-chips.com>,
        Kever Yang <kever.yang@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Sep 12, 2014 at 2:24 AM, Mark yao <mark.yao@rock-chips.com> wrote:
> The rk3288 actually has 12 softresets, so fix the register count.
>
> Signed-off-by: Mark yao <mark.yao@rock-chips.com>
> ---
>  drivers/clk/rockchip/clk-rk3288.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Doug Anderson <dianders@chromium.org>
