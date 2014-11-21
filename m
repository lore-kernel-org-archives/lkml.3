Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359AbaKUCmF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 21:42:05 -0500
Received: from mail-by2on0119.outbound.protection.outlook.com ([207.46.100.119]:3488
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756132AbaKUCmD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 21:42:03 -0500
From: Dexuan Cui <decui@microsoft.com>
To: KY Srinivasan <kys@microsoft.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
CC: Haiyang Zhang <haiyangz@microsoft.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: RE: [PATCH] hv: hv_fcopy: drop the obsolete message on transfer
 failure
Thread-Topic: [PATCH] hv: hv_fcopy: drop the obsolete message on transfer
 failure
Thread-Index: AQHP/ixzoWqBLlree0aJYfe1XGjx8ZxonIcQgACGI1CAALBG0IAAlUzA
Date: Fri, 21 Nov 2014 02:41:11 +0000
Message-ID: <F792CF86EFE20D4AB8064279AFBA51C613E5BE28@HKNPRD3002MB017.064d.mgd.msft.net>
References: <1415768606-28538-1-git-send-email-decui@microsoft.com>
 <BN1PR0301MB0707ED3958628389255649FCA0890@BN1PR0301MB0707.namprd03.prod.outlook.com>
 <F792CF86EFE20D4AB8064279AFBA51C613E577E6@HKNPRD3002MB017.064d.mgd.msft.net>
 <6b6a1089b0104b3fb9c2e785d058cd1d@BY2PR0301MB0711.namprd03.prod.outlook.com>
In-Reply-To: <6b6a1089b0104b3fb9c2e785d058cd1d@BY2PR0301MB0711.namprd03.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [141.251.55.132]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(438002)(52314003)(377454003)(199003)(13464003)(51704005)(189002)(164054003)(33656002)(97736003)(21056001)(2501002)(97756001)(99396003)(217423001)(551934003)(26826002)(2561002)(77096003)(77156002)(1511001)(66066001)(20776003)(4396001)(47776003)(62966003)(64706001)(68736004)(92726001)(69596002)(92566001)(87936001)(2656002)(107046002)(55846006)(15975445006)(86362001)(93886004)(106466001)(81156004)(2421001)(6806004)(106116001)(19580395003)(19580405001)(95666004)(44976005)(31966008)(54356999)(76176999)(46406003)(50466002)(16796002)(120916001)(2201001)(23726002)(50986999)(86146001)(86612001)(46102003)(84676001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB1214;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1214;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1214;
X-Forefront-PRVS: 0402872DA1
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1214;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1216;
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: KY Srinivasan
> Sent: Friday, November 21, 2014 1:58 AM
> To: Dexuan Cui; gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> driverdev-devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; jasowang@redhat.com
> Cc: Haiyang Zhang
> Subject: RE: [PATCH] hv: hv_fcopy: drop the obsolete message on transfer
> failure
> > -----Original Message-----
> > From: Dexuan Cui
> > Sent: Wednesday, November 19, 2014 11:48 PM
> > To: KY Srinivasan; gregkh@linuxfoundation.org; linux-
> > kernel@vger.kernel.org; driverdev-devel@linuxdriverproject.org;
> > olaf@aepfle.de; apw@canonical.com; jasowang@redhat.com
> > Cc: Haiyang Zhang
> > Subject: RE: [PATCH] hv: hv_fcopy: drop the obsolete message on transfer
> > failure
> >
> > > -----Original Message-----
> > > From: KY Srinivasan
> > > Sent: Thursday, November 20, 2014 6:59 AM
> > > > diff --git a/drivers/hv/hv_fcopy.c b/drivers/hv/hv_fcopy.c index
> > > > 23b2ce2..177122a 100644
> > > > --- a/drivers/hv/hv_fcopy.c
> > > > +++ b/drivers/hv/hv_fcopy.c
> > > > @@ -86,6 +86,15 @@ static void fcopy_work_func(struct
> work_struct
> > > > *dummy)
> > > >   * process the pending transaction.
> > > >   */
> > > >  fcopy_respond_to_host(HV_E_FAIL);
> > > > +
> > > > +/* In the case the user-space daemon crashes, hangs or is killed,
> > > > +we
> > > > + * need to down the semaphore, otherwise, after the daemon starts
> > > > next
> > > > + * time, the obsolete data in fcopy_transaction.message or
> > > > + * fcopy_transaction.fcopy_msg will be used immediately.
> > > > + */
> > > > +if (down_trylock(&fcopy_transaction.read_sema))
> > > > +pr_debug("FCP: failed to acquire the semaphore\n");
> > > > +
> > > >  }
> > >
> > > When the daemon is killed, we currently reset the state in the release
> > > function. Why can't we cleanup the semaphore state (initialize) here as
> > well.
> > >
> > > K. Y
> >
> > Hi KY,
> > 1) The down_trylock() here is necessary: the daemon can fail to respond
> in 5
> > seconds due to many reasons, e.g., the VM's CPU and I/O are too busy. In
> > this case, the daemon may become running later(NOTE: in this example,
> the
> > daemon is not killed), but from the host user's point of view, the
> PowerShell
> > copy-vmfile command has failed, so here we have to 'down' the
> semaphore
> > anyway, otherwise, the daemon can get obsolete data.
> >
> > 2) If we add a line
> > sema_init(&fcopy_transaction.read_sema, 0); in fcopy_release(), it seems
> > OK at a glance, but we have to handle the race
> > condition: the above down_trylock() and the sema_init() can, in theory,
> run
> > simultaneously on different virtual CPUs.  It's tricky to address this.
> >
> > 3) So I think we can reuse the same semaphore without an actually
> > unnecessary re-initialization. :-)
> 
> Agreed; you may want to get rid of the pr_debug() call though.
> 
> Thanks,
> 
> K. Y

The pr_debug() is added intentionally according to suggestion of 
Redhat's Vitaly Kuznetsov in the bugzilla:
https://bugzilla.redhat.com/show_bug.cgi?id=1162100#c5

The function is declared with__must_check in include/linux/semaphore.h:
extern int __must_check down_trylock(struct semaphore *sem);

Without checking the return value, we'll get these warning if the
"Kernel hacking" options are enabled:

drivers/hv/hv_fcopy.c: In function 'fcopy_work_func':
drivers/hv/hv_fcopy.c:95:2: warning: ignoring return value of 'down_trylock', declared with attribute warn_unused_result [-Wunused-result]
  (void)down_trylock(&fcopy_transaction.read_sema);
  ^

In practice, the message I add should be very rare since it's very unlikely to fail
to get the semaphore in this timeout case -- and in case this happens, it's actually
OK, because the driver has told the host user the PowerShell command should fail.

Thanks,
-- Dexuan
