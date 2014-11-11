Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbaKKH60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 02:58:26 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:43927 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751949AbaKKH6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 02:58:25 -0500
X-Listener-Flag: 11101
Subject: Re: [PATCH v5' 1/8] ARM: mediatek: Add basic support for mt8127
From: Yingjoe Chen <yingjoe.chen@mediatek.com>
To: Arnd Bergmann <arnd@arndb.de>, Matthias Brugger <matthias.bgg@gmail.com>
CC: Mark Rutland <mark.rutland@arm.com>, <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, <srv_heupstream@mediatek.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>, <hc.yen@mediatek.com>,
        <yh.chen@mediatek.com>, <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, <nathan.chung@mediatek.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>, Olof Johansson <olof@lixom.net>,
        <eddie.huang@mediatek.com>, <yingjoe.chen@gmail.com>
In-Reply-To: <1415692428-18416-1-git-send-email-yingjoe.chen@mediatek.com>
References: <1415086255-5555-1-git-send-email-yingjoe.chen@mediatek.com>
	 <1415692428-18416-1-git-send-email-yingjoe.chen@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Nov 2014 15:58:20 +0800
Message-ID: <1415692700.13629.26.camel@mtksdaap41>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, Matthias, Arnd,

After previous discussion[1], I'm not sure which one do you preferred
for mt8127/mt8135, so I send 64bits address version again. Trying to not
SPAM too much, I only send the difference(first 4 patches) this time.

We do have SoC that need >4GB address, so at least those will need to
use 64bits address. If we want to have a consistent look, 64bits is the
way to go. Also we already have some patches under review now using
64bits address. So I preferred this one, but both versions are OK to me.

Please help to review this and let me know anything you want me to
change. Thanks.

Joe.C

[1]
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-November/299598.html



