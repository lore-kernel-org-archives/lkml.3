Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbaFZUd1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 16:33:27 -0400
Received: from mail-by2lp0239.outbound.protection.outlook.com ([207.46.163.239]:44082
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750974AbaFZUdZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 16:33:25 -0400
From: Dexuan Cui <decui@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tomi.valkeinen@ti.com" <tomi.valkeinen@ti.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH] video: hyperv: hyperv_fb: refresh the VM screen by
 force on VM panic
Thread-Topic: [PATCH] video: hyperv: hyperv_fb: refresh the VM screen by
 force on VM panic
Thread-Index: AQHPj7Nk2+qPLBSStUGSkQVycxbGyZuAxfWwgAH6LACAARtKgA==
Date: Thu, 26 Jun 2014 20:32:42 +0000
Message-ID: <EE124450C0AAF944A40DD71E61F878C98402B1@SINEX14MBXC418.southpacific.corp.microsoft.com>
References: <1403569757-2622-1-git-send-email-decui@microsoft.com>
 <20140624135101.GB10115@kroah.com>
 <EE124450C0AAF944A40DD71E61F878C98353C6@SINEX14MBXC418.southpacific.corp.microsoft.com>
 <20140626033608.GA32654@kroah.com>
In-Reply-To: <20140626033608.GA32654@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.3.97]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(51704005)(189002)(199002)(164054003)(50986999)(46406003)(21056001)(81156004)(76176999)(76482001)(92566001)(99396002)(106466001)(54356999)(46102001)(86362001)(85306003)(4396001)(81542001)(97756001)(85852003)(77096002)(20776003)(83072002)(64706001)(47776003)(26826002)(80022001)(93886003)(23726002)(31966008)(55846006)(77982001)(81342001)(69596002)(86612001)(68736004)(106116001)(95666004)(16796002)(74662001)(2656002)(107046002)(33656002)(87936001)(6806004)(44976005)(84676001)(92726001)(97736001)(74502001)(83322001)(79102001)(50466002);DIR:OUT;SFP:;SCL:1;SRVR:CY1PR0301MB0842;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 02543CD7CD
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > >> MS-TFS: 157532
> >
> > > What is this line for?
> >
> > Hi Greg,
> > This line is for our internal bug repository.
> > We have an automated system to correlate bugs with fixes so that our test
> > team knows when a bug fix has been accepted upstream and they need to
> > write a new test case for it.
> >
> > The MS-TFS line has appeared in the commit description for a while if you
> > search for it in 'git log'  of linux-next.
> >
> > Please let us know if you have further comments.
> 
> Please don't add marker lines like this that provide no relevancy to
> anyone else.  I don't allow gerrit ids for the same reason.  If you want
> to refer to a public bug tracker, that's great, otherwise, don't
> include it.
> 
> greg k-h

Ok, I'll remove the line and re-submit a v2 patch(the patch itself will be
the same).

Thanks,
-- Dexuan
