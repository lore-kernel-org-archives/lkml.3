Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749AbbABCBa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 21:01:30 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:36789 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbbABCB1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 21:01:27 -0500
Date: Thu, 01 Jan 2015 21:01:22 -0500 (EST)
Message-Id: <20150101.210122.660970681208198668.davem@davemloft.net>
To: heiko@sntech.de
Cc: roger.chen@rock-chips.com, peppe.cavallaro@st.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        kever.yang@rock-chips.com, eddie.cai@rock-chips.com
Subject: Re: [PATCH v3 0/6] support GMAC driver for RK3288
From: David Miller <davem@davemloft.net>
In-Reply-To: <1493383.y3pPThNXY3@phil>
References: <1419846152-14531-1-git-send-email-roger.chen@rock-chips.com>
	<20141231.191538.585375391107637966.davem@davemloft.net>
	<1493383.y3pPThNXY3@phil>
X-Mailer: Mew version 6.6 on Emacs 24.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 01 Jan 2015 18:01:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Stübner <heiko@sntech.de>
Date: Thu, 01 Jan 2015 03:06:31 +0100

> Hi David,
> 
> Am Mittwoch, 31. Dezember 2014, 19:15:38 schrieb David Miller:
>> From: Roger Chen <roger.chen@rock-chips.com>
>> Date: Mon, 29 Dec 2014 17:42:32 +0800
>> 
>> > Roger Chen (6):
>> >   patch1: add driver for Rockchip RK3288 SoCs integrated GMAC
>> >   patch2: define clock ID used for GMAC
>> >   patch3: modify CRU config for Rockchip RK3288 SoCs integrated GMAC
>> >   patch4: dts: rockchip: add gmac info for rk3288
>> >   patch5: dts: rockchip: enable gmac on RK3288 evb board
>> >   patch6: add document for Rockchip RK3288 GMAC
>> > 
>> > Tested on rk3288 evb board:
>> > Execute the following command to enable ethernet,
>> > set local IP and ping a remote host.
>> > 
>> > busybox ifconfig eth0 up
>> > busybox ifconfig eth0 192.168.1.111
>> > ping 192.168.1.1
>> 
>> Series applied to net-next, thanks.
> 
> could we split this up a bit instead?

Too late, what's in my tree is in the permanent commit history
and cannot be deleted.
