Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbaLHUEc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 15:04:32 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46347 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934AbaLHUEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 15:04:30 -0500
Date: Mon, 8 Dec 2014 21:04:15 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Doug Anderson <dianders@chromium.org>
Cc: Wolfram Sang <wsa@the-dreams.de>, Addy Ke <addy.ke@rock-chips.com>,
        Max Schwarz <max.schwarz@online.de>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Tao Huang <huangtao@rock-chips.com>,
        Lin Huang <hl@rock-chips.com>,
        =?utf-8?B?5aea5pm65oOF?= <yzq@rock-chips.com>,
        Chris <zyw@rock-chips.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kever Yang <kever.yang@rock-chips.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Jianqun Xu <xjq@rock-chips.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        caesar <caesar.wang@rock-chips.com>, Eddie Cai <cf@rock-chips.com>,
        Han Jiang <hj@rock-chips.com>, Shunqian Zheng <zhengsq@rock-chips.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3] i2c: rk3x: fix bug that cause measured high_ns
 doesn't meet I2C spec
Message-ID: <20141208200415.GC13486@pengutronix.de>
References: <1415261514-4051-1-git-send-email-addy.ke@rock-chips.com>
 <1418007589-3688-1-git-send-email-addy.ke@rock-chips.com>
 <20141208085202.GA13486@pengutronix.de>
 <CAD=FV=V=PDPiDhDmd+j8ePsF43EvuFP-LxKgMKo7ZRBzSMyOJA@mail.gmail.com>
 <20141208173432.GA5732@katana>
 <CAD=FV=WQypHthEDPGUqVX3kzfFBSdj4H+_QY_=WYA3R77H+WiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAD=FV=WQypHthEDPGUqVX3kzfFBSdj4H+_QY_=WYA3R77H+WiQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Dec 08, 2014 at 10:53:44AM -0800, Doug Anderson wrote:
> So just to summarize for Addy, I think you're being asked to spin one more time.
> 
> 1. Update the patch description as per Uwe.  Fix other typos pointed out by him.
> 
> 2. Since you're spinning anyway, adjust "i2c" capitalization to "I2C".
> 
> 3. If you agree with Uwe, rename spec_max_data_hold_ns to
> spec_data_valid_ns.  If not, we should debate in a followup patch.
> 
> 4. If you think spec_data_hold_buffer_ns could be better represented
> in another way (should this be i2c-sda-falling-time-ns"?), please do
> so.  If not, we should debate in a followup patch.
Sounds all reasonable. I'd not address 3 and 4 in this patch, but do
this in separate one. (That's what I intended from the beginning, just
failed to point that out explicitly.)

Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
