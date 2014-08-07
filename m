Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510AbaHGAUj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 20:20:39 -0400
Received: from mail-by2lp0238.outbound.protection.outlook.com ([207.46.163.238]:51926
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753860AbaHGAUh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 20:20:37 -0400
From: Dexuan Cui <decui@microsoft.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH] Input: hyperv-keyboard: register as a wakeup source
Thread-Topic: [PATCH] Input: hyperv-keyboard: register as a wakeup source
Thread-Index: AQHPsbXAdiaprYMuL0WNzbflrRslv5vERqyg
Date: Thu, 7 Aug 2014 00:19:56 +0000
Message-ID: <EE124450C0AAF944A40DD71E61F878C9910E57@SINEX14MBXC417.southpacific.corp.microsoft.com>
References: <1406903304-7256-1-git-send-email-decui@microsoft.com>
 <20140806203339.GA22889@core.coreip.homeip.net>
In-Reply-To: <20140806203339.GA22889@core.coreip.homeip.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.3.88]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(51704005)(189002)(199002)(164054003)(377454003)(54534003)(13464003)(24454002)(74502001)(16796002)(15975445006)(106466001)(81156004)(85306004)(87936001)(19580395003)(44976005)(50986999)(2656002)(23726002)(54356999)(31966008)(84676001)(107046002)(68736004)(106116001)(83322001)(110136001)(6806004)(74662001)(19580405001)(85806002)(97756001)(97736001)(92726001)(85852003)(95666004)(92566001)(99396002)(83072002)(33656002)(26826002)(76176999)(77096002)(46102001)(50466002)(21056001)(76482001)(77982001)(46406003)(86362001)(79102001)(86612001)(4396001)(64706001)(69596002)(55846006)(81542001)(81342001)(20776003)(80022001)(47776003);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR0301MB0768;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 029651C7A1
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> Sent: Thursday, August 7, 2014 4:34 AM
> To: Dexuan Cui
> On Fri, Aug 01, 2014 at 07:28:24AM -0700, Dexuan Cui wrote:
> > With this patch, we can press a key to wake up the VM after the VM
> executes
> > "echo freeze > /sys/power/state".
> >
> > This addresses part of
> https://bugzilla.redhat.com/show_bug.cgi?id=1086100
> 
> I am sorry but this bug is not open to the public. Please avoid
> mentioning such bugs in changelogs. Otherwise I'll apply it.
Hi Dmitry,
Sorry, I didn't realize it's not public... :-)

I'll remove the line and re-send the patch.

Thanks,
-- Dexuan
