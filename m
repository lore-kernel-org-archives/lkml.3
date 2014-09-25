Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650AbaIYCQg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 22:16:36 -0400
Received: from mail-bn1on0118.outbound.protection.outlook.com ([157.56.110.118]:23040
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751232AbaIYCQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 22:16:35 -0400
Date: Thu, 25 Sep 2014 10:15:49 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Stefan Agner <stefan@agner.ch>
CC: <linus.walleij@linaro.org>, <gnurou@gmail.com>, <kernel@pengutronix.de>,
        <linux-gpio@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <bpringlemeir@nbsps.com>
Subject: Re: [PATCH v2 1/5] pinctrl: imx: detect uninitialized pins
Message-ID: <20140925021547.GA6405@dragon>
References: <cover.1411492954.git.stefan@agner.ch>
 <6d676a88eb82a47f8fa9e16abbc768e3e9ac236a.1411492954.git.stefan@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6d676a88eb82a47f8fa9e16abbc768e3e9ac236a.1411492954.git.stefan@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [180.108.234.93]
X-ClientProxiedBy: SIXPR03CA019.apcprd03.prod.outlook.com (10.141.119.29) To
 BY2PR03MB348.namprd03.prod.outlook.com (10.141.139.22)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB348;
X-Forefront-PRVS: 0345CFD558
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(24454002)(199003)(189002)(97736003)(54356999)(74662003)(31966008)(80022003)(46102003)(85852003)(81342003)(83072002)(86362001)(79102003)(83506001)(81542003)(99396003)(19580405001)(120916001)(77982003)(47776003)(107046002)(105586002)(110136001)(90102001)(87976001)(74502003)(33656002)(66066001)(10300001)(19580395003)(50986999)(92726001)(76482002)(102836001)(4396001)(95666004)(33716001)(77096002)(42186005)(97756001)(76176999)(83322001)(85306004)(20776003)(92566001)(21056001)(46406003)(50466002)(106356001)(101416001)(23726002)(64706001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB348;H:dragon;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 07:37:53PM +0200, Stefan Agner wrote:
> The pinctrl driver initialized the register offsets for the pins
> with 0. On Vybrid an offset of 0 is a valid offset for the pinctrl
> mux register. So far, this was solved using the ZERO_OFFSET_VALID
> flag which allowed offsets of 0. However, this does not allow to
> verify whether a pins struct imx_pmx_func was initialized or not.
> 
> Use signed offset values for register offsets and initialize those
> with -1 in order to detect uninitialized offset values reliable.
> 
> Signed-off-by: Stefan Agner <stefan@agner.ch>

Acked-by: Shawn Guo <shawn.guo@freescale.com>
