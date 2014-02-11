Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210AbaBKICD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 03:02:03 -0500
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:17640
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750776AbaBKIB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 03:01:58 -0500
Message-ID: <1392105685.2133.2.camel@e37108.spectralink.com>
Subject: Re: [PATCH] dp83640: Get gpio and master/slave configuration from DT
From: Stefan =?ISO-8859-1?Q?S=F8rensen?= 
	<stefan.sorensen@spectralink.com>
To: Richard Cochran <richardcochran@gmail.com>
CC: <grant.likely@linaro.org>, <robh+dt@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Date: Tue, 11 Feb 2014 09:01:25 +0100
In-Reply-To: <20140210184604.GA4296@netboy>
References: <1392037240-30913-1-git-send-email-stefan.sorensen@spectralink.com>
	 <20140210184604.GA4296@netboy>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [213.83.164.162]
X-ClientProxiedBy: DB3PR01CA009.eurprd01.prod.exchangelabs.com
 (10.255.177.26) To DM2PR07MB334.namprd07.prod.outlook.com (10.141.98.12)
X-Forefront-PRVS: 0119DC3B5E
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(6009001)(6049001)(51704005)(199002)(189002)(24454002)(377424004)(50226001)(4396001)(94316002)(81816001)(85852003)(92566001)(87266001)(54316002)(92726001)(56776001)(59766001)(42186004)(87976001)(79102001)(94946001)(76482001)(77982001)(1411001)(76786001)(76796001)(63696002)(77156001)(47736001)(47776003)(83072002)(93916002)(47976001)(49866001)(50986001)(53806001)(77096001)(87286001)(81686001)(88136002)(74706001)(93516002)(31966008)(80022001)(69226001)(95416001)(46102001)(81542001)(81342001)(50466002)(66066001)(93136001)(65816001)(74662001)(85306002)(47446002)(86362001)(51856001)(90146001)(74502001)(89996001)(74876001)(56816005)(83322001)(23676002)(80976001)(74366001)(95666001)(33646001)(62966002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR07MB334;H:[172.29.194.63];CLIP:213.83.164.162;FPR:2CE9E8A0.A3FE5F89.6FE9833F.4E65FF79.201D8;InfoNoRecordsA:1;MX:1;LANG:en;
X-OriginatorOrg: spectralink.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-10 at 19:46 +0100, Richard Cochran wrote:
> On Mon, Feb 10, 2014 at 02:00:40PM +0100, Stefan Sørensen wrote:
> > This patch removes the module parameters gpio_tab and chosen_phy in favour of
> > retrieving the configuration from DT through the properties
> 
> Can we please keep the module parameters? I have two platforms with
> phyters neither of which will ever support DT, namely ixp and m68k,
> and I want to run recent kernels on them.

I will keep the module parameters as fallback. Will it be OK to split
the gpio_tab parameter into separate calibrate-pin, perout-pins and
extts-pins parameters?

> > The configuration is now stored for each master clock device, allowing different 
> > gpio setups for each master.
> 
> What do you mean by "each master"? Do you mean each individual PHY device
> or each group of PHYs on the same MDIO bus?

I mean each group of PHYs. I will reword that.

Stefan


