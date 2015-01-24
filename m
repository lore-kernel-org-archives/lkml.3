Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829AbbAXPOL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 10:14:11 -0500
Received: from gloria.sntech.de ([95.129.55.99]:35854 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348AbbAXPOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 10:14:07 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: dri-devel@lists.freedesktop.org
Cc: Mark Yao <mark.yao@rock-chips.com>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, Rob Clark <robdclark@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Daniel Kurtz <djkurtz@chromium.org>, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Subject: Re: [PATCH] drm/rockchip: vop: fix vop vsync/hsync polarity
Date: Sat, 24 Jan 2015 16:13:46 +0100
Message-ID: <6363536.7mHnmGACNi@phil>
User-Agent: KMail/4.14.2 (Linux/3.16.0-4-amd64; KDE/4.14.1; x86_64; ; )
In-Reply-To: <1421896502-9943-1-git-send-email-mark.yao@rock-chips.com>
References: <1421896502-9943-1-git-send-email-mark.yao@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 22. Januar 2015, 11:15:02 schrieb Mark Yao:
> Vop set wrong vsync/hsync polarity, it may cause some
> display problem. known problem is that caused HDMI hdcp
> authenticate failed, caused pixel offset with hdmi display.
> the polarity description at RK3288 TRM doc:
>   dsp_vsync_pol
>     VSYNC polarity
>       1'b0 : negative
>       1'b1 : positive
>       dsp_hsync_pol
>     HSYNC polarity
>       1'b0 : negative
>       1'b1 : positive
> 
> Signed-off-by: Mark Yao <mark.yao@rock-chips.com>
> ---

on a rk3288-firefly board with a sda7123 vga connector
Tested-by: Heiko Stuebner <heiko@sntech.de>


Heiko
