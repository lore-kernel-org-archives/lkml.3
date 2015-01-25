Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbbAYVXX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 16:23:23 -0500
Received: from gloria.sntech.de ([95.129.55.99]:43019 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684AbbAYVXW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 16:23:22 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: tglx@linutronix.de, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org
Subject: Re: [PATCH V2] clockevents: rockchip: Add rockchip timer for rk3288
Date: Sun, 25 Jan 2015 22:28:21 +0100
Message-ID: <1728434.WELQfpY90C@diego>
User-Agent: KMail/4.14.1 (Linux/3.16-3-amd64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <54C55D1A.9010706@linaro.org>
References: <1422178979-12382-1-git-send-email-daniel.lezcano@linaro.org> <2285293.ZBcGIuxxDo@diego> <54C55D1A.9010706@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

Am Sonntag, 25. Januar 2015, 22:16:10 schrieb Daniel Lezcano:
> On 01/25/2015 09:52 PM, Heiko Stübner wrote:
> > one big request and some more style nitpicks :-)
> > 
> > With the nitpicks fixed
> > Reviewed-by: Heiko Stuebner <heiko@sntech.de>
> > 
> > 
> > Before applying this patch could you drop the rk3288.dtsi change please?
> > Instead I'd like to add the following patch separately to _my_ devicetree
> > branch for 3.20.
> > 
> > I already wasn't fast enough to prevent the ethernet controller changes
> > going through the network tree and would like to prevent a third tree
> > sending changes for the same dts area to Linus - merge conflicts and all.
> > 
> > 
> > I don't think that neither the nitpicks nor dropping the dtsi segment need
> > another submission though.
> 
> Hi Heiko,
> 
> I removed the dtsi change, fixed the spaces indentation and pushed in my
> tree the driver [1]

and I pushed the corresponding dt change to [2] and am going to send the
pull request to arm-soc in the next days.


Heiko


[2] https://git.kernel.org/cgit/linux/kernel/git/mmind/linux-rockchip.git/log/?h=v3.20-armsoc/dts
