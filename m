Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbaKKLlq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:41:46 -0500
Received: from mga02.intel.com ([134.134.136.20]:57963 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218AbaKKLln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:41:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="486471314"
Message-ID: <5461F5D8.7050700@linux.intel.com>
Date: Tue, 11 Nov 2014 19:41:12 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
CC: Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>, arm@kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Grant Likely <grant.likely@linaro.org>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, srv_heupstream@mediatek.com,
        yingjoe.chen@gmail.com, hc.yen@mediatek.com, eddie.huang@mediatek.com,
        nathan.chung@mediatek.com, yh.chen@mediatek.com,
        Sascha Hauer <kernel@pengutronix.de>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v5 0/6] ARM: mediatek: Add support for interrupt polarity
References: <1414576824-16143-1-git-send-email-yingjoe.chen@mediatek.com> <20141109053820.GU3698@titan.lakedaemon.net> <alpine.DEB.2.11.1411111234220.3935@nanos>
In-Reply-To: <alpine.DEB.2.11.1411111234220.3935@nanos>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014/11/11 19:35, Thomas Gleixner wrote:
> On Sun, 9 Nov 2014, Jason Cooper wrote:
> 
>> Thomas, Marc,
>>
>> Could I get Acks for the core changes and gic changes when you have
>> a moment?
> 
> this depends on the core irqdomain changes which are not yet in
> tip. I'm waiting for Jiangs latest iteration and Marcs feedback on
> those.
Hi Thomas,
	Sorry for dealy:)
	I think my previous version is good for merging. I only need to
update one patch to address a possible conflict on other architectures.
I'm testing the patch and should send it out soon.
Regards!
Gerry

> 
> Thanks,
> 
> 	tglx
> 
