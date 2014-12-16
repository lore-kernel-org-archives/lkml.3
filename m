Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481AbaLPQfQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 11:35:16 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:48380 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbaLPQfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 11:35:12 -0500
Date: Tue, 16 Dec 2014 08:34:06 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Matthias Brugger <matthias.bgg@gmail.com>
Cc: wim@iguana.be, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-watchdog@vger.kernel.org,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Yingjoe Chen <yingjoe.chen@gmail.com>,
        Howard Chen <ibanezchen@gmail.com>, greta.zhang@mediatek.com,
        huang eddie <eddie.huang@mediatek.com>
Subject: Re: [PATCH v2 2/2] ARM: mediatek: dts: Add bindings for watchdog
Message-ID: <20141216163406.GB26966@roeck-us.net>
References: <1418395859-32209-1-git-send-email-matthias.bgg@gmail.com>
 <1418395859-32209-3-git-send-email-matthias.bgg@gmail.com>
 <548C5F1F.8070804@roeck-us.net>
 <CABuKBe+=PaJ2BuhoGGwn8V20207QU3zzWb4UGgXzwwF-AvBEPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABuKBe+=PaJ2BuhoGGwn8V20207QU3zzWb4UGgXzwwF-AvBEPw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A010202.54905F3F.01B9,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 12
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 05:14:35PM +0100, Matthias Brugger wrote:
> 2014-12-13 16:45 GMT+01:00 Guenter Roeck <linux@roeck-us.net>:
> > On 12/12/2014 06:50 AM, Matthias Brugger wrote:
> >>
> >> Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
> >> ---
> >>   Documentation/devicetree/bindings/watchdog/mtk-wdt.txt | 13
> >> +++++++++++++
> >>   1 file changed, 13 insertions(+)
> >>   create mode 100644
> >> Documentation/devicetree/bindings/watchdog/mtk-wdt.txt
> >>
> >> diff --git a/Documentation/devicetree/bindings/watchdog/mtk-wdt.txt
> >> b/Documentation/devicetree/bindings/watchdog/mtk-wdt.txt
> >> new file mode 100644
> >> index 0000000..af9eb5b
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/watchdog/mtk-wdt.txt
> >> @@ -0,0 +1,13 @@
> >> +Mediatek SoCs Watchdog timer
> >> +
> >> +Required properties:
> >> +
> >> +- compatible : should be "mediatek,mt6589-wdt"
> >
> >
> > "mediatek" is undefined as vendor prefix in the current upstream code.
> > Is this vendor prefix coming in from another patch set ?
> 
> Strange, should be in vendor-prefix.txt [1].
> Please double check.
> 
Sorry, I misunderstood the output from checkpatch.

Guenter
