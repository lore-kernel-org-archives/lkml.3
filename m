Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654AbaAJDYF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 22:24:05 -0500
Received: from mail-bn1blp0181.outbound.protection.outlook.com ([207.46.163.181]:43031
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751766AbaAJDYD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 22:24:03 -0500
From: Shaohui Xie <Shaohui.Xie@freescale.com>
To: David Miller <davem@davemloft.net>,
        "shh.xie@gmail.com" <shh.xie@gmail.com>
CC: "jg1.han@samsung.com" <jg1.han@samsung.com>,
        "mugunthanvnm@ti.com" <mugunthanvnm@ti.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 3/6] [v5] phylib: turn genphy_driver to an array
Thread-Topic: [PATCH 3/6] [v5] phylib: turn genphy_driver to an array
Thread-Index: AQHPDDc3QsAhx7VtukGoJe1lT/M1B5p9Q2uAgAAJrZA=
Date: Fri, 10 Jan 2014 03:24:00 +0000
Message-ID: <629d5079e0974452bcf60a0a56bec749@BLUPR03MB067.namprd03.prod.outlook.com>
References: <1389155240-15996-1-git-send-email-shh.xie@gmail.com>
 <20140109.214447.242793673746496044.davem@davemloft.net>
In-Reply-To: <20140109.214447.242793673746496044.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.50]
x-forefront-prvs: 00872B689F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(377454003)(13464003)(51704005)(199002)(189002)(85852003)(19580395003)(56776001)(56816005)(90146001)(81342001)(47446002)(76576001)(76796001)(74502001)(76786001)(33646001)(19580405001)(83322001)(77096001)(83072002)(81542001)(85306002)(69226001)(4396001)(63696002)(31966008)(54316002)(74662001)(66066001)(81686001)(87266001)(2656002)(92566001)(80022001)(51856001)(76482001)(65816001)(53806001)(74366001)(77982001)(59766001)(81816001)(74706001)(87936001)(49866001)(50986001)(47736001)(47976001)(74316001)(46102001)(80976001)(54356001)(79102001)(74876001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB065;H:BLUPR03MB067.namprd03.prod.outlook.com;CLIP:123.151.195.50;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Friday, January 10, 2014 10:45 AM
> To: shh.xie@gmail.com
> Cc: jg1.han@samsung.com; mugunthanvnm@ti.com; f.fainelli@gmail.com;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Xie Shaohui-B21989
> Subject: Re: [PATCH 3/6] [v5] phylib: turn genphy_driver to an array
> 
> 
> Many of these patches give rejects when I try to apply them to net-next,
> you will need to respin this series.
> 
[S.H] These patches were based on Linus's tree. I'll rebase them to the net-next.
I'm Sorry for inconvenient!

Thank you!

Best Regards, 
Shaohui Xie


