Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751046AbaKXXgE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 18:36:04 -0500
Received: from gloria.sntech.de ([95.129.55.99]:58297 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbaKXXgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 18:36:01 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Caesar Wang <caesar.wang@rock-chips.com>, rui.zhang@intel.com,
        zyf@rock-chips.com, dianders@chromium.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        cf@rock-chips.com, dmitry.torokhov@gmail.com, huangtao@rock-chips.com,
        fzf@rock-chips.com
Subject: Re: [PATCH v19 0/5] Rockchip soc thermal driver
Date: Tue, 25 Nov 2014 00:39:43 +0100
Message-ID: <1771961.FfLxNDNiti@diego>
User-Agent: KMail/4.14.1 (Linux/3.16-3-amd64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <20141124201807.GA20404@developer>
References: <1416805142-27304-1-git-send-email-caesar.wang@rock-chips.com> <20141124201807.GA20404@developer>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Caesar,

Am Montag, 24. November 2014, 16:18:12 schrieb Eduardo Valentin:
> Hello Caesar,
> 
> On Mon, Nov 24, 2014 at 12:58:57PM +0800, Caesar Wang wrote:
> > This series patchs tested on rk3288 SDK board and pinky-v1,v2 board.
> > I believe the driver can be used on the rk3288-evb board.
> > 
> > Add this driver, The system will shutdown when
> > the thermal temperture over 100C.If for some reason we are unable to
> > shut it down in orderly fashion (kernel is stuck holding a lock or
> > similar)
> > then hardware will reset it.
> > 
> > The patchs 1/5,2/5 can applay Eduardo's Branch
> > git://git.kernel.org/pub/scm/linux/kernel/git/evalenti/linux-soc-thermal.g
> > it [branch "next-kernel"]
> > 
> > 	remote = origin
> > 	merge = refs/heads/next
> 
> I applied your patches 1 and 2 in my -linus branch, and luckily will be
> accepted for 3.19.

and I've taken patches 3, 4 and 5 into my dts branch for 3.19 .

I've adapted the commit messages in some places and removed the
	/* sensor		ID */
comments from the rk3288-thermal.dtsi.


Heiko
