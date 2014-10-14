Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226AbaJNNNp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 09:13:45 -0400
Received: from mail-by2on0105.outbound.protection.outlook.com ([207.46.100.105]:39072
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755247AbaJNNNn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 09:13:43 -0400
From: Thomas Shao <huishao@microsoft.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "olaf@aepfle.de" <olaf@aepfle.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: RE: [PATCH 2/2] hyperv: Implement Time Synchronization using host
 time sample
Thread-Topic: [PATCH 2/2] hyperv: Implement Time Synchronization using host
 time sample
Thread-Index: AQHP55ZRTp/VO8CmfEuTJogFjyVUzJwvcjOAgAAW4JCAAAguAIAAAGBQ
Date: Tue, 14 Oct 2014 13:13:03 +0000
Message-ID: <CD2CABCB2C0A0D4682C5F8AD840141540BFD90@HKXPRD3002MB006.064d.mgd.msft.net>
References: <1413285078-7027-1-git-send-email-huishao@microsoft.com>
 <20141014111915.GV23154@mwanda>
 <CD2CABCB2C0A0D4682C5F8AD840141540BFD19@HKXPRD3002MB006.064d.mgd.msft.net>
 <20141014131024.GX23154@mwanda>
In-Reply-To: <20141014131024.GX23154@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [61.173.50.55]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(438002)(13464003)(24454002)(51704005)(189002)(199003)(377454003)(55846006)(4396001)(85852003)(2656002)(87936001)(77096002)(64706001)(21056001)(66066001)(47776003)(97736003)(46102003)(46406003)(86362001)(107046002)(20776003)(93886004)(80022003)(99396003)(110136001)(23726002)(86612001)(26826002)(50466002)(120916001)(86146001)(6806004)(44976005)(84676001)(95666004)(85306004)(106116001)(76176999)(76482002)(19580405001)(81156004)(92566001)(106466001)(31966008)(97756001)(68736004)(92726001)(50986999)(19580395003)(16796002)(54356999)(33656002)(69596002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB605;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB605;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03648EFF89
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=huishao@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Tuesday, October 14, 2014 9:10 PM
> To: Thomas Shao
> Cc: olaf@aepfle.de; gregkh@linuxfoundation.org; jasowang@redhat.com;
> linux-kernel@vger.kernel.org; apw@canonical.com;
> devel@linuxdriverproject.org; tglx@linutronix.de
> Subject: Re: [PATCH 2/2] hyperv: Implement Time Synchronization using host
> time sample
> 
> On Tue, Oct 14, 2014 at 12:50:23PM +0000, Thomas Shao wrote:
> > > > -static inline void do_adj_guesttime(u64 hosttime)
> > > > +static inline void do_adj_guesttime(u64 hosttime, bool forceSync)
> > >
> > > I'm surprise checkpatch.pl does't complain about this CamelCase.
> >
> > I've run the scripts/checkpatch.pl, it didn't complain anything. I'll change to
> forcesync.
> 
> ->force_sync is normal kernel style.

OK, got it. Thanks Dan!

> 
> regards,
> dan carpenter

