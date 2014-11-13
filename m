Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471AbaKMKRm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 05:17:42 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:49668 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932174AbaKMKRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 05:17:39 -0500
X-Listener-Flag: 11101
Subject: Re: [PATCH v5' 1/8] ARM: mediatek: Add basic support for mt8127
From: Yingjoe Chen <yingjoe.chen@mediatek.com>
To: Matthias Brugger <matthias.bgg@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>, Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        srv_heupstream <srv_heupstream@mediatek.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        HC Yen <hc.yen@mediatek.com>, Yuhau Chen <yh.chen@mediatek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Nathan Chung <nathan.chung@mediatek.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>, Olof Johansson <olof@lixom.net>,
        huang eddie <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@gmail.com>
In-Reply-To: <CABuKBeK3-h79sb1i32r-YbgCMVWFy-CEVobieW3VC7TsQJj1ew@mail.gmail.com>
References: <1415086255-5555-1-git-send-email-yingjoe.chen@mediatek.com>
	 <1415692428-18416-1-git-send-email-yingjoe.chen@mediatek.com>
	 <1415692700.13629.26.camel@mtksdaap41>
	 <CABuKBeK3-h79sb1i32r-YbgCMVWFy-CEVobieW3VC7TsQJj1ew@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Nov 2014 18:17:34 +0800
Message-ID: <1415873854.17958.38.camel@mtksdaap41>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-12 at 18:08 +0100, Matthias Brugger wrote:
> Hi Joe,
> 
> 2014-11-11 8:58 GMT+01:00 Yingjoe Chen <yingjoe.chen@mediatek.com>:
> >
> > Hi, Matthias, Arnd,
> >
> > After previous discussion[1], I'm not sure which one do you preferred
> > for mt8127/mt8135, so I send 64bits address version again. Trying to not
> > SPAM too much, I only send the difference(first 4 patches) this time.
> >
> > We do have SoC that need >4GB address, so at least those will need to
> > use 64bits address. If we want to have a consistent look, 64bits is the
> > way to go. Also we already have some patches under review now using
> > 64bits address. So I preferred this one, but both versions are OK to me.
> 
> Regarding Arnd's last email, the 64 bit is the right way.

Hi Matthias,

Ok, please use this v5' then.
Thanks,

Joe.C


