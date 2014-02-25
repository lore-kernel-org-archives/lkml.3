Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461AbaBYFPZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 00:15:25 -0500
Received: from mail-by2lp0239.outbound.protection.outlook.com ([207.46.163.239]:24553
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750738AbaBYFPW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 00:15:22 -0500
From: Peter Chen <Peter.Chen@freescale.com>
To: Neil Zhang <zhangwm@marvell.com>
CC: "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/6] usb: gadget: mv_udc: disable HW zlt for ep0
Thread-Topic: [PATCH 2/6] usb: gadget: mv_udc: disable HW zlt for ep0
Thread-Index: AQHPMTdfHn6q0sLFtkmQnfSG9aPWEJrFsrSA//+qwwCAABEV4A==
Date: Tue, 25 Feb 2014 05:15:19 +0000
Message-ID: <6ad74d797ecc473f922ffdb58c3e9c70@BN1PR03MB235.namprd03.prod.outlook.com>
References: <1393228996-14787-1-git-send-email-zhangwm@marvell.com>
 <1393228996-14787-3-git-send-email-zhangwm@marvell.com>
 <20140225011839.GD7540@shlinux1.ap.freescale.net>
 <175CCF5F49938B4D99B2E3EF7F558EBE54EC413563@SC-VEXCH4.marvell.com>
In-Reply-To: <175CCF5F49938B4D99B2E3EF7F558EBE54EC413563@SC-VEXCH4.marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.50]
x-forefront-prvs: 01334458E5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(51704005)(24454002)(199002)(189002)(92566001)(86362001)(47446002)(31966008)(94946001)(74502001)(74662001)(74316001)(95416001)(94316002)(85306002)(53806001)(54356001)(54316002)(76482001)(33646001)(83322001)(2656002)(95666003)(83072002)(81686001)(87266001)(79102001)(74366001)(74876001)(80976001)(51856001)(81816001)(85852003)(87936001)(46102001)(77982001)(59766001)(49866001)(47976001)(47736001)(50986001)(81342001)(65816001)(66066001)(80022001)(69226001)(63696002)(74706001)(77096001)(81542001)(76786001)(76796001)(56776001)(56816005)(93136001)(90146001)(76576001)(93516002)(4396001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB407;H:BN1PR03MB235.namprd03.prod.outlook.com;CLIP:123.151.195.50;FPR:2EC2FD62.EA10409.72D88FA3.14CEAF30.20112;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



 
> > On Mon, Feb 24, 2014 at 04:03:12PM +0800, Neil Zhang wrote:
> > > Hardware zlt will try to send the zero length packet automatically
> > > when the data transferd is multiple times of max packet, this will
> > > cause issues on Windows.
> > > So let's disable HW zlt by default.
> >
> > Would you have description that what kinds of issue on Windows if zlt
> > is is selected?
> >
> 
> Enumeration will fail.
> 

What causes enumeration fail, why it does not occur before?

Peter
