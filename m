Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbaKLRIH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 12:08:07 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:46651 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988AbaKLRIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 12:08:05 -0500
MIME-Version: 1.0
In-Reply-To: <1415692700.13629.26.camel@mtksdaap41>
References: <1415086255-5555-1-git-send-email-yingjoe.chen@mediatek.com>
	<1415692428-18416-1-git-send-email-yingjoe.chen@mediatek.com>
	<1415692700.13629.26.camel@mtksdaap41>
Date: Wed, 12 Nov 2014 18:08:02 +0100
Message-ID: <CABuKBeK3-h79sb1i32r-YbgCMVWFy-CEVobieW3VC7TsQJj1ew@mail.gmail.com>
Subject: Re: [PATCH v5' 1/8] ARM: mediatek: Add basic support for mt8127
From: Matthias Brugger <matthias.bgg@gmail.com>
To: Yingjoe Chen <yingjoe.chen@mediatek.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Mark Rutland <mark.rutland@arm.com>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

2014-11-11 8:58 GMT+01:00 Yingjoe Chen <yingjoe.chen@mediatek.com>:
>
> Hi, Matthias, Arnd,
>
> After previous discussion[1], I'm not sure which one do you preferred
> for mt8127/mt8135, so I send 64bits address version again. Trying to not
> SPAM too much, I only send the difference(first 4 patches) this time.
>
> We do have SoC that need >4GB address, so at least those will need to
> use 64bits address. If we want to have a consistent look, 64bits is the
> way to go. Also we already have some patches under review now using
> 64bits address. So I preferred this one, but both versions are OK to me.

Regarding Arnd's last email, the 64 bit is the right way.

Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>

>
> Please help to review this and let me know anything you want me to
> change. Thanks.
>
> Joe.C
>
> [1]
> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-November/299598.html
>
>
>



-- 
motzblog.wordpress.com
