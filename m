Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbaBMEoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 23:44:14 -0500
Received: from mail-bn1lp0158.outbound.protection.outlook.com ([207.46.163.158]:55754
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbaBMEoM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 23:44:12 -0500
From: Yibin Gong <yibin.gong@freescale.com>
To: Shawn Guo <shawn.guo@linaro.org>
CC: "broonie@kernel.org" <broonie@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shijie.huang@freescale.com" <shijie.huang@freescale.com>,
        "Frank.Li@freescale.com" <Frank.Li@freescale.com>
Subject: RE: [PATCH V1] spi: imx: add dma support for ecspi
Thread-Topic: [PATCH V1] spi: imx: add dma support for ecspi
Thread-Index: AQHPKF7JOGe2Xpv7tEat7xKyOE9yM5qyljyQ
Date: Thu, 13 Feb 2014 04:28:46 +0000
Message-ID: <68125bae8279423c9caf1a8ddc29ea97@BLUPR03MB036.namprd03.prod.outlook.com>
References: <1392199379-6742-1-git-send-email-b38343@freescale.com>
 <20140213015617.GA950@S2101-09.ap.freescale.net>
In-Reply-To: <20140213015617.GA950@S2101-09.ap.freescale.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.158.211]
x-forefront-prvs: 0121F24F22
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(13464003)(24454002)(189002)(199002)(51704005)(377454003)(74876001)(94946001)(93516002)(76482001)(93136001)(15975445006)(46102001)(53806001)(54356001)(81542001)(74706001)(56816005)(51856001)(83072002)(85852003)(74316001)(69226001)(94316002)(86362001)(81342001)(90146001)(74366001)(31966008)(74662001)(92566001)(63696002)(76576001)(66066001)(76786001)(76796001)(19580395003)(65816001)(80022001)(85306002)(47446002)(15202345003)(59766001)(87936001)(33646001)(79102001)(80976001)(77982001)(2656002)(74502001)(4396001)(56776001)(54316002)(47736001)(49866001)(87266001)(95416001)(81816001)(95666001)(81686001)(50986001)(77096001)(19580405001)(47976001)(83322001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB487;H:BLUPR03MB036.namprd03.prod.outlook.com;CLIP:192.88.158.211;FPR:E0EF60D2.2F818D2A.D3F0994B.C36EE90D.2018C;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I miss the message .Thanks Shawn's reminding and thanks Sascha's comments and I will talk with Frank.

-----Original Message-----
From: Shawn Guo [mailto:shawn.guo@linaro.org] 
Sent: Thursday, February 13, 2014 9:56 AM
To: Gong Yibin-B38343
Cc: broonie@kernel.org; s.hauer@pengutronix.de; linux-spi@vger.kernel.org; linux-kernel@vger.kernel.org; Huang Shijie-B32955
Subject: Re: [PATCH V1] spi: imx: add dma support for ecspi

On Wed, Feb 12, 2014 at 06:02:59PM +0800, Robin Gong wrote:
> Add basical dma support for ecspi. Validate on i.MX6qsabresd board.
> 
> Signed-off-by: Robin Gong <b38343@freescale.com>

Robin,

Are you aware of the submission [1] from Frank Li?  You may want to coordinate the effort with him.

Shawn

[1] http://thread.gmane.org/gmane.linux.ports.arm.kernel/291722

