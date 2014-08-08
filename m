Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281AbaHHPwc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 11:52:32 -0400
Received: from gloria.sntech.de ([95.129.55.99]:40439 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756142AbaHHPwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 11:52:31 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Doug Anderson <dianders@chromium.org>
Cc: Kever Yang <kever.yang@rock-chips.com>,
        Paul Zimmerman <paulz@synopsys.com>, Olof Johansson <olof@lixom.net>,
        Sonny Rao <sonnyrao@chromium.org>, Addy Ke <addy.ke@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, Jianqun Xu <xjq@rock-chips.com>,
        wulf <wulf@rock-chips.com>, lyz <lyz@rock-chips.com>,
        han jiang <hj@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 3/4] ARM: dts: add rk3288 dwc2 controller support
Date: Fri, 08 Aug 2014 17:53:45 +0200
Message-ID: <1596739.u7ZntKLW7r@diego>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <CAD=FV=XNSp85H2zVrLPdxDfhokEWFspvwUHjVMWRu8k_wFFm0Q@mail.gmail.com>
References: <1407470159-14722-1-git-send-email-kever.yang@rock-chips.com> <1407470159-14722-4-git-send-email-kever.yang@rock-chips.com> <CAD=FV=XNSp85H2zVrLPdxDfhokEWFspvwUHjVMWRu8k_wFFm0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 8. August 2014, 08:45:16 schrieb Doug Anderson:
> Kever,
> 
> On Thu, Aug 7, 2014 at 8:55 PM, Kever Yang <kever.yang@rock-chips.com> 
wrote:
> > rk3288 has two kind of usb controller, this add the dwc2 controller
> > for otg and host1.
> > 
> > Controller can works with usb PHY default setting and Vbus on.
> > 
> > Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> > Reviewed-by: Doug Anderson <dianders@chromium.org>
> > Tested-by: Doug Anderson <dianders@chromium.org>
> > ---
> > 
> > Changes in v5:
> > - change the sort order of dwc2 in rk3288.dtsi
> > 
> > Changes in v4: None
> > Changes in v3:
> > - EHCI and HSIC move new for version 3.
> > 
> > Changes in v2: None
> > 
> >  arch/arm/boot/dts/rk3288.dtsi | 20 ++++++++++++++++++++
> >  1 file changed, 20 insertions(+)
> 
> IMHO this series is ready to go in for 3.18.  I'm assuming Heiko will
> pick it up once the bindings have landed.  It already has my tags.  ;)

correct ... the dts changes look ok, so I'll take patches 3 and 4 once patches 
1 and 2 are included somewhere.


Heiko
