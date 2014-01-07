Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbaAGHEv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 02:04:51 -0500
Received: from mail-bn1blp0186.outbound.protection.outlook.com ([207.46.163.186]:29019
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753283AbaAGHEs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 02:04:48 -0500
From: Shaohui Xie <Shaohui.Xie@freescale.com>
To: David Miller <davem@davemloft.net>,
        "shh.xie@gmail.com" <shh.xie@gmail.com>
CC: "jg1.han@samsung.com" <jg1.han@samsung.com>,
        "mugunthanvnm@ti.com" <mugunthanvnm@ti.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "afleming@gmail.com" <afleming@gmail.com>
Subject: RE: [PATCH 5/6] [v4] phylib: Support attaching to generic 10g driver
Thread-Topic: [PATCH 5/6] [v4] phylib: Support attaching to generic 10g
 driver
Thread-Index: AQHPC1p3FDOeT9ey5UWp4xHijrVHipp4w5uAgAASpjA=
Date: Tue, 7 Jan 2014 07:04:35 +0000
Message-ID: <242e28ff23a8472a8e13d2f32c764374@BN1PR03MB069.namprd03.prod.outlook.com>
References: <1389060865-7143-1-git-send-email-shh.xie@gmail.com>
 <20140107.005607.716747884959539511.davem@davemloft.net>
In-Reply-To: <20140107.005607.716747884959539511.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.50]
x-forefront-prvs: 008421A8FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(51704005)(377454003)(189002)(199002)(13464003)(74316001)(74366001)(33646001)(56776001)(76796001)(85306002)(76786001)(76576001)(77982001)(59766001)(66066001)(80022001)(65816001)(79102001)(63696002)(47736001)(49866001)(4396001)(47976001)(50986001)(76482001)(54316002)(74502001)(74706001)(47446002)(74876001)(74662001)(31966008)(83322001)(19580405001)(19580395003)(69226001)(54356001)(51856001)(46102001)(53806001)(81686001)(83072002)(85852003)(80976001)(56816005)(2656002)(87266001)(90146001)(87936001)(81542001)(81342001)(77096001)(81816001)(41533002)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR03MB071;H:BN1PR03MB069.namprd03.prod.outlook.com;CLIP:123.151.195.50;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Tuesday, January 07, 2014 1:56 PM
> To: shh.xie@gmail.com
> Cc: jg1.han@samsung.com; mugunthanvnm@ti.com; f.fainelli@gmail.com;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Xie Shaohui-B21989;
> afleming@gmail.com
> Subject: Re: [PATCH 5/6] [v4] phylib: Support attaching to generic 10g
> driver
> 
> From: <shh.xie@gmail.com>
> Date: Tue, 7 Jan 2014 10:14:25 +0800
> 
> > -static int phy_attach_direct(struct net_device *dev, struct
> > phy_device *phydev,
> > +int phy_attach_direct(struct net_device *dev, struct phy_device
> > +*phydev,
> >  			     u32 flags, phy_interface_t interface)
> 
> Since you are changing where the open parenthesis is, you must reindent
> the arguments on the second line so that they start exactly at the first
> column after that openning parenthesis.
> 
[S.H] OK. Thank you!
Will fix it in next version.

Best Regards, 
Shaohui Xie
