Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab3DVDNC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 23:13:02 -0400
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:55489 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133Ab3DVDNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 23:13:00 -0400
X-Greylist: delayed 2762 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Apr 2013 23:12:57 EDT
From: Barry Song <Barry.Song@csr.com>
To: Stephen Boyd <sboyd@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Thomas Abraham" <thomas.abraham@linaro.org>,
        DL-SHA-WorkGroupLinux <Workgroup.Linux@csr.com>
Subject: RE: [PATCHv5 00/11] Remove ARM local timer API
Thread-Topic: [PATCHv5 00/11] Remove ARM local timer API
Thread-Index: AQHOPRnGG9tq6EnauUuV8kUAwVekWJjhhqoQ
Date: Mon, 22 Apr 2013 02:26:24 +0000
Message-ID: <5EB3BFCD089AD643B9BB63439F5FD5E9012A244417@SHAASIEXM01.ASIA.ROOT.PRI>
References: <1366388385-30722-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1366388385-30722-1-git-send-email-sboyd@codeaurora.org>
Accept-Language: en-US, zh-CN, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.125.36.70]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3M3D9oZ002208

> -----Original Message-----
> From: Stephen Boyd [mailto:sboyd@codeaurora.org]
> Sent: Saturday, April 20, 2013 12:20 AM
> To: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org; linux-arm-msm@vger.kernel.org; Mark
> Rutland; Marc Zyngier; Kukjin Kim; Barry Song; Daniel Walker; Bryan Huntsman;
> Tony Lindgren; John Stultz; Thomas Gleixner; Thomas Abraham
> Subject: [PATCHv5 00/11] Remove ARM local timer API
> 
> In light of Mark Rutland's recent work on divorcing the ARM architected
> timers from the ARM local timer API and introducing a generic arch hook for
> broadcast it seems that we should remove the local timer API entirely.
> Doing so will reduce the architecture dependencies of our timer drivers,
> reduce code in ARM core, and simplify timer drivers because they no longer
> go through an architecture layer that is essentially a hotplug notifier.
> 
> Previous attempts have been made[1] unsuccessfully. I'm hoping this can
> be accepted now so that we can clean up the timer drivers that are
> used in both UP and SMP situations. Right now these drivers have to ignore
> the timer setup callback on the boot CPU to avoid registering clockevents
> twice. This is not very symmetric and causes convuluted code that does
> the same thing in two places.
> 
> Patches based on next-20130418
> 
> I'm still looking for Acks/Tested-by on EXYNOS and PRIMA2.

Stephen, I hope I can give a test soon. But I have some others in higher priority now.

> [1] http://article.gmane.org/gmane.linux.ports.arm.kernel/145705

-barry


Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
More information can be found at www.csr.com. Follow CSR on Twitter at http://twitter.com/CSR_PLC and read our blog at www.csr.com/blog
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
