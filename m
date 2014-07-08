Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153AbaGHWSJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:18:09 -0400
Received: from mail-bn1blp0189.outbound.protection.outlook.com ([207.46.163.189]:22899
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751269AbaGHWSG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:18:06 -0400
From: Dexuan Cui <decui@microsoft.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        "tomi.valkeinen@ti.com" <tomi.valkeinen@ti.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH v2] video: hyperv: hyperv_fb: refresh the VM screen by
 force on VM panic
Thread-Topic: [PATCH v2] video: hyperv: hyperv_fb: refresh the VM screen by
 force on VM panic
Thread-Index: AQHPmo7K9bmiR/mw30qA8kPuB/vMKpuWvrIA
Date: Tue, 8 Jul 2014 22:17:48 +0000
Message-ID: <EE124450C0AAF944A40DD71E61F878C987A663@SINEX14MBXC417.southpacific.corp.microsoft.com>
References: <1403818501-15547-1-git-send-email-decui@microsoft.com>
 <20140708092709.GI25880@mwanda>
In-Reply-To: <20140708092709.GI25880@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.3.86]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(164054003)(377454003)(13464003)(51704005)(199002)(189002)(81542001)(20776003)(86362001)(81156004)(77096002)(106466001)(6806004)(68736004)(46102001)(64706001)(69596002)(106116001)(85806002)(19580395003)(79102001)(44976005)(31966008)(19580405001)(23726002)(86612001)(83322001)(50466002)(85306003)(84676001)(33656002)(74662001)(81342001)(99396002)(16796002)(26826002)(55846006)(107046002)(77982001)(50986999)(83072002)(54356999)(92566001)(85852003)(97756001)(76176999)(95666004)(87936001)(76482001)(46406003)(21056001)(97736001)(2656002)(47776003)(110136001)(74502001)(80022001)(92726001)(4396001);DIR:OUT;SFP:;SCL:1;SRVR:CY1PR0301MB1180;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 0266491E90
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Tuesday, July 8, 2014 17:27 PM
> To: Dexuan Cui
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org; plagnioj@jcrosoft.com;
> tomi.valkeinen@ti.com; linux-fbdev@vger.kernel.org; olaf@aepfle.de;
> apw@canonical.com; jasowang@redhat.com; Haiyang Zhang
> Subject: Re: [PATCH v2] video: hyperv: hyperv_fb: refresh the VM screen by
> force on VM panic
> 
> Don't use likely/unlikely unless you have benchmark numbers to show that
> it makes a speed up.
> 
> regards,
> dan carpenter

Hi Dan,
Here the variable 'synchronous_fb' is only set to true when the system panics.
So before the system panics, it's always 'unlikely'. :-)

Thanks,
-- Dexuan
