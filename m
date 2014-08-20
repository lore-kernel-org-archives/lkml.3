Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642AbaHTNna (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 09:43:30 -0400
Received: from mail-bn1lp0140.outbound.protection.outlook.com ([207.46.163.140]:23003
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752386AbaHTNnG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 09:43:06 -0400
From: Dexuan Cui <decui@microsoft.com>
To: Sitsofe Wheeler <sitsofe@gmail.com>
CC: KY Srinivasan <kys@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Kylie Liang <kyliel@microsoft.com>
Subject: RE: [PANIC, hyperv] BUG: unable to handle kernel paging request at
 ffff880077800004 (hv_ringbuffer_write)
Thread-Topic: [PANIC, hyperv] BUG: unable to handle kernel paging request at
 ffff880077800004 (hv_ringbuffer_write)
Thread-Index: AQHPvFjgvav2zR0lYke3SB9WxJlS05vZVRgggAAJOQCAACEkgA==
Date: Wed, 20 Aug 2014 13:42:48 +0000
Message-ID: <EE124450C0AAF944A40DD71E61F878C993DB3D@SINEX14MBXC417.southpacific.corp.microsoft.com>
References: <20140820092630.GA1478@sucs.org>
 <EE124450C0AAF944A40DD71E61F878C993BD4E@SINEX14MBXC417.southpacific.corp.microsoft.com>
 <20140820114014.GB7980@sucs.org>
In-Reply-To: <20140820114014.GB7980@sucs.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.3.92]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(199003)(13464003)(189002)(51914003)(164054003)(51704005)(377454003)(74502001)(47776003)(77982001)(81342001)(26826002)(92726001)(80022001)(86362001)(68736004)(50986999)(85306004)(81156004)(76482001)(107046002)(74662001)(54356999)(79102001)(69596002)(16796002)(23726002)(33656002)(92566001)(77096002)(97736001)(76176999)(31966008)(55846006)(85806002)(110136001)(106116001)(83322001)(85852003)(84676001)(6806004)(99396002)(87936001)(19580395003)(4396001)(95666004)(46406003)(50466002)(81542001)(20776003)(86612001)(106466001)(21056001)(46102001)(97756001)(1411001)(15975445006)(44976005)(83072002)(64706001)(2656002);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB241;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 03094A4065
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Sitsofe Wheeler
> Sent: Wednesday, August 20, 2014 19:40 PM
> > I suppose you're using  the latest mainline v3.17-rc1(7d1311b9).
> 
> That's right - Linux 3.17-rc1
> (7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9).
Ok, let me try to reproduce it first.

> > Can you please attach your kernel config file so that I can try to reproduce
> > the issue more easily?
> 
> Sure (it's pretty much the same one mentioned in
> https://lkml.org/lkml/2014/8/19/101 and
> https://lkml.org/lkml/2014/8/19/708 but those don't seem framebuffer
> related) but just in case I'll attach it to this mail.
Thanks for the info! 

> > Do you mean the issue only happens to UP guest and doesn't happen to
> > SMP guest?
> 
> Yes - if in Windows I go to Hyper-V Manager, press the right mouse
> button over the guest and go to Settings..., click on Processor at the
> left and set the Number of virtual processors to 1 on the right then
> this issue occurs. If the number is greater than 1 then this does not
> seem to occur.
It's strange SMP guest is ok while UP is not ok. :-(

Thanks,
-- Dexuan
