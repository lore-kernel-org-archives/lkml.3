Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbaCDHQL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 02:16:11 -0500
Received: from mail-bl2lp0203.outbound.protection.outlook.com ([207.46.163.203]:50920
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756574AbaCDHQI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 02:16:08 -0500
X-Greylist: delayed 939 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Mar 2014 02:16:08 EST
From: Yibin Gong <yibin.gong@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] regulator: pfuze100: add pfuze200 support
Thread-Topic: [PATCH v2] regulator: pfuze100: add pfuze200 support
Thread-Index: AQHPN3WQRWmYe9faREydUZiu7y1B45rQfTvw
Date: Tue, 4 Mar 2014 07:00:26 +0000
Message-ID: <346e4e7976cf41f79c32484d93aaf06c@BLUPR03MB036.namprd03.prod.outlook.com>
References: <1393911933-25149-1-git-send-email-b38343@freescale.com>
 <20140304064642.GA13126@sirena.org.uk>
In-Reply-To: <20140304064642.GA13126@sirena.org.uk>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 01401330D1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(189002)(199002)(377454003)(13464003)(24454002)(76482001)(81816001)(46102001)(51856001)(54356001)(77096001)(53806001)(76576001)(56776001)(76786001)(93516002)(81686001)(54316002)(74876001)(69226001)(80022001)(92566001)(66066001)(83072002)(93136001)(65816001)(63696002)(85852003)(74502001)(81542001)(83322001)(81342001)(76796001)(19580395003)(47446002)(74706001)(74316001)(87266001)(77982001)(74366001)(59766001)(79102001)(87936001)(74662001)(56816005)(47976001)(95666003)(19580405001)(50986001)(95416001)(2656002)(94316002)(80976001)(47736001)(90146001)(86362001)(49866001)(31966008)(94946001)(4396001)(85306002)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB408;H:BLUPR03MB036.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:E8DC6492.2E039C2E.41E3334F.14E66A8D.201B9;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,
	Thanks for your reminding, PFUZE200 is currently validated on the same board(i.MX6Q Sabresd) which mounted with PFUZE100 before. So the patch only adding driver level support to let others can easily add PFUZE200 support once they have the PFUZE200 board. 

-----Original Message-----
From: Mark Brown [mailto:broonie@kernel.org] 
Sent: Tuesday, March 04, 2014 2:47 PM
To: Gong Yibin-B38343
Cc: lgirdwood@gmail.com; linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] regulator: pfuze100: add pfuze200 support

On Tue, Mar 04, 2014 at 01:45:33PM +0800, Robin Gong wrote:
> support pfuze200 chip which remove SW1C and SW4 based on pfuze100.

Applied, thanks - however I just noticed that you forgot to add the compatible string for the new part to the DT binding, please send a followup doing that.
