Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464AbaHGIvF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 04:51:05 -0400
Received: from mail-bl2lp0211.outbound.protection.outlook.com ([207.46.163.211]:47027
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757378AbaHGIu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 04:50:58 -0400
Date: Thu, 7 Aug 2014 16:50:26 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Anson Huang <b20788@freescale.com>
CC: <edubezval@gmail.com>, <rui.zhang@intel.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH V3] Thermal: imx: add i.mx6sx thermal support
Message-ID: <20140807085024.GE27051@dragon>
References: <1407309129-5562-1-git-send-email-b20788@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1407309129-5562-1-git-send-email-b20788@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130518750434240029;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009003)(6009001)(448002)(51704005)(199002)(189002)(24454002)(81542001)(83322001)(19580405001)(46406003)(85326001)(19580395003)(102836001)(6806004)(79102001)(26826002)(23726002)(99396002)(64706001)(44976005)(50466002)(80022001)(87936001)(97756001)(107046002)(20776003)(47776003)(81342001)(33716001)(97736001)(68736004)(104016003)(84676001)(74502001)(74662001)(83072002)(50986999)(85852003)(21056001)(76176999)(85306004)(92566001)(4396001)(57986006)(33656002)(76482001)(110136001)(86362001)(54356999)(46102001)(92726001)(77982001)(95666004)(31966008)(83506001)(106466001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB363;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 029651C7A1
Authentication-Results: spf=permerror (sender IP is 192.88.168.50)
 smtp.mailfrom=shawn.guo@linaro.org; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 03:12:09PM +0800, Anson Huang wrote:
> i.MX6SX has some new features of thermal interrupt function,
> there are LOW, HIGH and PANIC irq for thermal sensor, so add
> platform data to separate different thermal version;
> 
> The reset value of LOW ALARM is 0 which means the highest
> temp, so the LOW ALARM will be triggered once irq is enabled,
> so we need to correct it before enabling thermal irq;
> 
> Enable PANIC ALARM as critical trip point, it will trigger
> system reset via SRC module once PANIC IRQ is triggered, it
> is pure hardware function, so use it instead of software
> reset by cooling device.
> 
> Signed-off-by: Anson Huang <b20788@freescale.com>

Tested-by: Shawn Guo <shawn.guo@linaro.org>
