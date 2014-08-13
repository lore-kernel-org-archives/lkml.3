Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbaHMF2s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 01:28:48 -0400
Received: from mail-by2lp0244.outbound.protection.outlook.com ([207.46.163.244]:22076
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751137AbaHMF2r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 01:28:47 -0400
From: Dexuan Cui <decui@microsoft.com>
To: KY Srinivasan <kys@microsoft.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Vojtech Pavlik <vojtech@suse.cz>
CC: Greg KH <gregkh@linuxfoundation.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH] Input: serio: make HYPERV_KEYBOARD depend on
 SERIO_I8042=y
Thread-Topic: [PATCH] Input: serio: make HYPERV_KEYBOARD depend on
 SERIO_I8042=y
Thread-Index: AQHPtfL80p5QO0TZ/0qF/qigPt99A5vMiCDwgAC47oCAAAILAIAAvu8g
Date: Wed, 13 Aug 2014 05:27:36 +0000
Message-ID: <EE124450C0AAF944A40DD71E61F878C9925D3D@SINEX14MBXC417.southpacific.corp.microsoft.com>
References: <1407814240-4275-1-git-send-email-decui@microsoft.com>
 <20140812032148.GB6867@kroah.com>
 <EE124450C0AAF944A40DD71E61F878C9920A1C@SINEX14MBXC417.southpacific.corp.microsoft.com>
 <20140812060108.GA13231@kroah.com>
 <EE124450C0AAF944A40DD71E61F878C9920EAF@SINEX14MBXC417.southpacific.corp.microsoft.com>
 <20140812175435.GA22386@core.coreip.homeip.net>
 <423148fadd52409a95064eca25e71340@BY2PR0301MB0711.namprd03.prod.outlook.com>
In-Reply-To: <423148fadd52409a95064eca25e71340@BY2PR0301MB0711.namprd03.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.3.93]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(51704005)(13464003)(52604005)(189002)(164054003)(199003)(31966008)(74502001)(64706001)(106116001)(74662001)(86362001)(95666004)(81156004)(50466002)(16796002)(33656002)(83322001)(106466001)(85306004)(21056001)(77096002)(92566001)(107046002)(93886004)(81542001)(20776003)(23726002)(54356999)(85806002)(99396002)(97736001)(76176999)(68736004)(50986999)(2656002)(87936001)(84676001)(97756001)(46102001)(69596002)(77982001)(26826002)(4396001)(55846006)(92726001)(80022001)(86612001)(46406003)(47776003)(44976005)(76482001)(2421001)(6806004)(83072002)(1511001)(81342001)(79102001)(561944003)(85852003);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB255;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 0302D4F392
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: KY Srinivasan
> > The Arch users can simply select to build i8042 into the kernel as a
> > workaround.
> >
> > The proper solution is to allow loading libps2 module even if i8042 did not
> find
> > its device. I wish I could simply drop this i8042_lock_chip and stuff, but
> > unfortunately i8042 ports are not truly independent. We need to figure a
> > way for libps2 to engage locking in i8042 if the driver is loaded, otherwise
> just
> > ignore it.
> 
> When I first wrote this driver, we took the decision not to replicate all the
> code in the at keyboard driver and to
> make this  a serio based driver. I like the proposal made by Dmitry here.
> 
> K. Y

Thanks for explaining the background, KY!
I like Dmitry's proposal too.

Thanks,
-- Dexuan
