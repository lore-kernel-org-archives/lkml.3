Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229AbbACW1j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 17:27:39 -0500
Received: from gloria.sntech.de ([95.129.55.99]:36955 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbbACW1h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 17:27:37 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: David Miller <davem@davemloft.net>
Cc: roger.chen@rock-chips.com, peppe.cavallaro@st.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        kever.yang@rock-chips.com, eddie.cai@rock-chips.com
Subject: Re: [PATCH v3 0/6] support GMAC driver for RK3288
Date: Sat, 03 Jan 2015 23:27:18 +0100
Message-ID: <3223311.vXMaSqpKME@phil>
User-Agent: KMail/4.14.2 (Linux/3.16-3-amd64; KDE/4.14.1; x86_64; ; )
In-Reply-To: <20150101.210122.660970681208198668.davem@davemloft.net>
References: <1419846152-14531-1-git-send-email-roger.chen@rock-chips.com> <1493383.y3pPThNXY3@phil> <20150101.210122.660970681208198668.davem@davemloft.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 1. Januar 2015, 21:01:22 schrieb David Miller:
> From: Heiko Stübner <heiko@sntech.de>
> Date: Thu, 01 Jan 2015 03:06:31 +0100
> 
> > Hi David,
> > 
> > Am Mittwoch, 31. Dezember 2014, 19:15:38 schrieb David Miller:
> >> From: Roger Chen <roger.chen@rock-chips.com>
> >> Date: Mon, 29 Dec 2014 17:42:32 +0800
> >> 
> >> > Roger Chen (6):
> >> >   patch1: add driver for Rockchip RK3288 SoCs integrated GMAC
> >> >   patch2: define clock ID used for GMAC
> >> >   patch3: modify CRU config for Rockchip RK3288 SoCs integrated GMAC
> >> >   patch4: dts: rockchip: add gmac info for rk3288
> >> >   patch5: dts: rockchip: enable gmac on RK3288 evb board
> >> >   patch6: add document for Rockchip RK3288 GMAC
> >> > 
> >> > Tested on rk3288 evb board:
> >> > Execute the following command to enable ethernet,
> >> > set local IP and ping a remote host.
> >> > 
> >> > busybox ifconfig eth0 up
> >> > busybox ifconfig eth0 192.168.1.111
> >> > ping 192.168.1.1
> >> 
> >> Series applied to net-next, thanks.
> > 
> > could we split this up a bit instead?
> 
> Too late, what's in my tree is in the permanent commit history
> and cannot be deleted.

ok no problem ... I'll work around it then so that any possible conflicts are 
easily solvable.


Heiko
