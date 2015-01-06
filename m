Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571AbbAFNwE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 08:52:04 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:47029 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754602AbbAFNwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 08:52:01 -0500
Date: Tue, 6 Jan 2015 13:51:29 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Andy Yan <andy.yan@rock-chips.com>
Cc: Daniel Kurtz <djkurtz@chromium.org>, David Airlie <airlied@linux.ie>,
        Philipp Zabel <p.zabel@pengutronix.de>, fabio.estevam@freescale.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        Josh Boyer <jwboyer@redhat.com>, Sean Paul <seanpaul@chromium.org>,
        Inki Dae <inki.dae@samsung.com>, Dave Airlie <airlied@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Lucas Stach <l.stach@pengutronix.de>,
        Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>,
        Yakir Yang <ykk@rock-chips.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        devel@driverdev.osuosl.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Xu Jianqun <jay.xu@rock-chips.com>, Pawel Moll <pawel.moll@arm.com>,
        "mark.yao@rock-chips.com" <mark.yao@rock-chips.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, vladimir_zapolskiy@mentor.com
Subject: Re: [PATCH v18 12/12] drm: bridge/dw_hdmi: add rockchip rk3288
 support
Message-ID: <20150106135129.GG12302@n2100.arm.linux.org.uk>
References: <1417760564-16858-1-git-send-email-andy.yan@rock-chips.com>
 <1417761259-17429-1-git-send-email-andy.yan@rock-chips.com>
 <CAGS+omA1Gf8yqrd4Bu=Pm1OBdsJBHg0gt+TP_6vi88Zz+O3jHA@mail.gmail.com>
 <6479148.dVz0vTNYfK@phil>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6479148.dVz0vTNYfK@phil>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 12:24:15PM +0100, Heiko Stübner wrote:
> Past practices suggest that having the dw in the name is a sane solution too, 
> like in dw_mmc-foo (mmc/host), dwmac-foo (net/ethernet/stmicro/stmmac).
> 
> And personally I'd keep to this already established naming scheme ... i.e. not 
> hiding the dw heritage.
> 
> And also it looks like other involved parties like Philipp and Russell seemed 
> to be ok with the naming through the revisions till now.

I don't have much of a preference when it comes to this.  I was disappointed
that the original imx-hdmi driver did not use "dw" in its filename, as the
documentation clearly stated in several places that it was a designware
part, and as we all know, they're a company which sells IP, so their
designs are going to crop up in different places.

So I welcome this patch set - and I've also tested it on a SolidRun
Hummingboard i2ex along with all my CEC and audio patches, where it
seems to be fine.  So for the set:

Tested-by: Russell King <rmk+kernel@arm.linux.org.uk>

Apart from the two minor items I've pointed out in separate replies:

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

Thanks.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
