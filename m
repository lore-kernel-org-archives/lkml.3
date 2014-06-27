Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643AbaF0XuJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 19:50:09 -0400
Received: from mail-bn1lp0142.outbound.protection.outlook.com ([207.46.163.142]:52317
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754129AbaF0XuH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 19:50:07 -0400
From: "Yue Zhang (OSTC DEV)" <yuezha@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: KY Srinivasan <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "apw@canonical.com" <apw@canonical.com>,
        Thomas Shao <huishao@microsoft.com>
Subject: RE: [PATCH] Tools: hv: fix file overwriting of hv_fcopy_daemon
Thread-Topic: [PATCH] Tools: hv: fix file overwriting of hv_fcopy_daemon
Thread-Index: AQHPkl6O8sAqmAA3okOB2ausX6ehY5uFnu6A////zxA=
Date: Fri, 27 Jun 2014 23:45:47 +0000
Message-ID: <DC7803B42427924284F2D5252E076A3B4472C23B@SINEX14MBXC404.southpacific.corp.microsoft.com>
References: <1403914608-21604-1-git-send-email-yuezha@microsoft.com>
 <20140627234511.GA1044@kroah.com>
In-Reply-To: <20140627234511.GA1044@kroah.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.3.92]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(189002)(199002)(13464003)(51704005)(106116001)(97736001)(50986999)(92726001)(54356999)(106466001)(81156004)(81342001)(81542001)(47776003)(107046002)(68736004)(86612001)(64706001)(20776003)(80022001)(77982001)(86362001)(76176999)(69596002)(21056001)(76482001)(74662001)(74502001)(16796002)(4396001)(31966008)(23726002)(85306003)(55846006)(2656002)(26826002)(87936001)(46102001)(77096002)(83322001)(50466002)(6806004)(99396002)(46406003)(19580395003)(44976005)(33656002)(97756001)(84676001)(92566001)(95666004)(79102001)(85852003)(83072002)(19580405001);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR0301MB0595;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 0255DF69B9
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=yuezha@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> > From: Yue Zhang <yuezha@microsoft.com>
> >
> > hv_fcopy_daemon fails to overwrite a file if the target file already
> > exits.
> >
> > Add O_TRUNC flag on opening.
> >
> > MS-TFS: 341345
> 
> It's as if the people on your team don't talk to each other about what they
> should, or should not, include in their patch descriptions...
> 
> Please remove.

Sorry for this. It is added by mistake. I will remove it.

Yue Zhang
