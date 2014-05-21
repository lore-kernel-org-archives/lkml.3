Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbaEULdD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 07:33:03 -0400
Received: from mail-bl2lp0207.outbound.protection.outlook.com ([207.46.163.207]:13443
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752342AbaEULc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 07:32:59 -0400
From: Appana Durga Kedareswara Rao <appana.durga.rao@xilinx.com>
To: Marc Kleine-Budde <mkl@pengutronix.de>,
        "wg@grandegger.com" <wg@grandegger.com>,
        Michal Simek <michals@xilinx.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>
CC: "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v8 2/2] can: xilinx CAN controller support.
Thread-Topic: [PATCH v8 2/2] can: xilinx CAN controller support.
Thread-Index: AQHPdOfeEMgl0Smao0yYxudgrwK4optK5qjg
Date: Wed, 21 May 2014 11:32:41 +0000
References: <30fc07d6-4404-4745-8c03-1c5ae775e4f1@BY2FFO11FD047.protection.gbl>
 <537C8E00.404@pengutronix.de>
In-Reply-To: <537C8E00.404@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.16.44]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-RCIS-Action: ALLOW
Message-ID: <72e9a444-0de4-42ce-a9d3-ee247948f0e6@BN1AFFO11FD030.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438001)(24454002)(13464003)(377454003)(479174003)(199002)(189002)(51704005)(83072002)(2656002)(85852003)(77982001)(79102001)(74662001)(92726001)(87936001)(47776003)(20776003)(64706001)(86362001)(16601075003)(33646001)(76482001)(15202345003)(15975445006)(21056001)(31696002)(53416003)(80022001)(23676002)(50466002)(19580395003)(74316001)(81342001)(99396002)(70736001)(83322001)(44976005)(19580405001)(50986999)(54356999)(76176999)(46102001)(4396001)(74502001)(81542001)(23106003);DIR:OUT;SFP:;SCL:1;SRVR:BN1AFFO11HUB008;H:xsj-gw1;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Forefront-PRVS: 0218A015FA
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=appana.durga.rao@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s4LBXEVf019238

Hi Marc,

        Yes for DT-bindings Rob already had given ack.
Sorry I forgot to add the Acked-by line in that patch.

Regards,
Kedar.

> -----Original Message-----
> From: Marc Kleine-Budde [mailto:mkl@pengutronix.de]
> Sent: Wednesday, May 21, 2014 4:59 PM
> To: Appana Durga Kedareswara Rao; wg@grandegger.com; Michal Simek;
> grant.likely@linaro.org; robh+dt@kernel.org
> Cc: linux-can@vger.kernel.org; netdev@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; linux-kernel@vger.kernel.org; Appana Durga
> Kedareswara Rao
> Subject: Re: [PATCH v8 2/2] can: xilinx CAN controller support.
>
> On 05/21/2014 09:00 AM, Kedareswara rao Appana wrote:
> > This patch adds xilinx CAN controller support.
> > This driver supports both ZYNQ CANPS and Soft IP AXI CAN controller.
> >
> > Signed-off-by: Kedareswara rao Appana <appanad@xilinx.com>
>
> Looks good, do you already have an Ack for the DT-bindings?
>
> Marc
>
> --
> Pengutronix e.K.                  | Marc Kleine-Budde           |
> Industrial Linux Solutions        | Phone: +49-231-2826-924     |
> Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
> Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |



This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
