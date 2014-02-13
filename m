Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849AbaBMOYl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 09:24:41 -0500
Received: from [207.46.163.151] ([207.46.163.151]:47314 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751560AbaBMOX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 09:23:56 -0500
Message-ID: <1392301403.2585.11.camel@e37108.spectralink.com>
Subject: Re: [PATCH v2 2/2] dp83640: Get pin and master/slave configuration
 from DT
From: Stefan =?ISO-8859-1?Q?S=F8rensen?= 
	<stefan.sorensen@spectralink.com>
To: Richard Cochran <richardcochran@gmail.com>
CC: <grant.likely@linaro.org>, <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Date: Thu, 13 Feb 2014 15:23:23 +0100
In-Reply-To: <20140211201917.GB4254@netboy>
References: <1392132562-23644-1-git-send-email-stefan.sorensen@spectralink.com>
	 <1392132562-23644-3-git-send-email-stefan.sorensen@spectralink.com>
	 <20140211201917.GB4254@netboy>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.83.164.162]
X-ClientProxiedBy: DB3PR06CA004.eurprd06.prod.outlook.com (10.255.71.21) To
 DM2PR07MB334.namprd07.prod.outlook.com (10.141.98.12)
X-Forefront-PRVS: 0121F24F22
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(6009001)(6049001)(24454002)(377424004)(199002)(189002)(51704005)(74662001)(85306002)(47446002)(93136001)(66066001)(65816001)(50466002)(56816005)(74876001)(86362001)(89996001)(74502001)(90146001)(51856001)(74706001)(69226001)(80022001)(95416001)(88136002)(46102001)(93516002)(81342001)(81542001)(83322001)(33646001)(95666001)(62966002)(74366001)(80976001)(23676002)(31966008)(85852003)(92566001)(56776001)(87266001)(92726001)(50226001)(4396001)(94316002)(81816001)(93916002)(47736001)(83072002)(47976001)(53806001)(47776003)(63696002)(76786001)(77156001)(87286001)(54316002)(76796001)(81686001)(49866001)(77096001)(50986001)(87976001)(94946001)(79102001)(59766001)(42186004)(1411001)(77982001)(76482001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR07MB334;H:[172.29.194.63];CLIP:213.83.164.162;FPR:FF11DA96.BD2E65A9.3E4330B.76E11261.20121;InfoNoRecordsA:1;MX:1;LANG:en;
X-OriginatorOrg: spectralink.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-11 at 21:19 +0100, Richard Cochran wrote:
> > +- dp83640,slave: If present, this phy will be slave to another dp83640
> > +  on the same mdio bus.
> 
> Wouldn't it be more natural to have one "dp83640,master" property
> rather than multiple slave properties?

I wanted to keep the common case of a single phy simple, i.e. no need to
specify any master/slave properties. 

> Most of these pr_err lines are a bit _way_ too long for coding style.

I will fix that in the next version.

Stefan


