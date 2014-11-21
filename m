Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788AbaKUS34 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 13:29:56 -0500
Received: from mail-bn1bon0110.outbound.protection.outlook.com ([157.56.111.110]:34720
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750892AbaKUS3z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 13:29:55 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Dexuan Cui <decui@microsoft.com>,
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
Thread-Index: AQHP/ixzoWqBLlree0aJYfe1XGjx8ZxonIcQgACGI1CAALBG0IAAlUzAgAEL0jA=
Date: Fri, 21 Nov 2014 18:29:51 +0000
Message-ID: <63c8e399f3234b68b611da3c199fbaf2@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1415768606-28538-1-git-send-email-decui@microsoft.com>
 <BN1PR0301MB0707ED3958628389255649FCA0890@BN1PR0301MB0707.namprd03.prod.outlook.com>
 <F792CF86EFE20D4AB8064279AFBA51C613E577E6@HKNPRD3002MB017.064d.mgd.msft.net>
 <6b6a1089b0104b3fb9c2e785d058cd1d@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <F792CF86EFE20D4AB8064279AFBA51C613E5BE28@HKNPRD3002MB017.064d.mgd.msft.net>
In-Reply-To: <F792CF86EFE20D4AB8064279AFBA51C613E5BE28@HKNPRD3002MB017.064d.mgd.msft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e0:ee43::3]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0710;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0710;
x-forefront-prvs: 0402872DA1
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(52314003)(164054003)(51704005)(199003)(189002)(377454003)(13464003)(33646002)(105586002)(77096003)(77156002)(62966003)(40100003)(31966008)(106356001)(120916001)(76576001)(99396003)(21056001)(95666004)(106116001)(15975445006)(20776003)(217423001)(87936001)(50986999)(93886004)(108616004)(1511001)(2656002)(64706001)(122556002)(107046002)(76176999)(54356999)(99286002)(2421001)(86612001)(2501002)(551934003)(92566001)(86362001)(2201001)(19580405001)(19580395003)(74316001)(101416001)(97736003)(46102003)(4396001)(2561002)(3826002)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0710;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Dexuan Cui
> Sent: Thursday, November 20, 2014 6:41 PM
> To: KY Srinivasan; gregkh@linuxfoundation.org; linux-
> kernel@vger.kernel.org; driverdev-devel@linuxdriverproject.org;
> olaf@aepfle.de; apw@canonical.com; jasowang@redhat.com
> Cc: Haiyang Zhang; Vitaly Kuznetsov
> Subject: RE: [PATCH] hv: hv_fcopy: drop the obsolete message on transfer
> failure
> 
> > -----Original Message-----
> > From: KY Srinivasan
> > Sent: Friday, November 21, 2014 1:58 AM
> > To: Dexuan Cui; gregkh@linuxfoundation.org;
> > linux-kernel@vger.kernel.org; driverdev-devel@linuxdriverproject.org;
> > olaf@aepfle.de; apw@canonical.com; jasowang@redhat.com
> > Cc: Haiyang Zhang
> > Subject: RE: [PATCH] hv: hv_fcopy: drop the obsolete message on
> > transfer failure
> > > -----Original Message-----
> > > From: Dexuan Cui
> > > Sent: Wednesday, November 19, 2014 11:48 PM
> > > To: KY Srinivasan; gregkh@linuxfoundation.org; linux-
> > > kernel@vger.kernel.org; driverdev-devel@linuxdriverproject.org;
> > > olaf@aepfle.de; apw@canonical.com; jasowang@redhat.com
> > > Cc: Haiyang Zhang
> > > Subject: RE: [PATCH] hv: hv_fcopy: drop the obsolete message on
> > > transfer failure
> > >
> > > > -----Original Message-----
> > > > From: KY Srinivasan
> > > > Sent: Thursday, November 20, 2014 6:59 AM
> > > > > diff --git a/drivers/hv/hv_fcopy.c b/drivers/hv/hv_fcopy.c index
> > > > > 23b2ce2..177122a 100644
> > > > > --- a/drivers/hv/hv_fcopy.c
> > > > > +++ b/drivers/hv/hv_fcopy.c
> > > > > @@ -86,6 +86,15 @@ static void fcopy_work_func(struct
> > work_struct
> > > > > *dummy)
> > > > >   * process the pending transaction.
> > > > >   */
> > > > >  fcopy_respond_to_host(HV_E_FAIL);
> > > > > +
> > > > > +/* In the case the user-space daemon crashes, hangs or is
> > > > > +killed, we
> > > > > + * need to down the semaphore, otherwise, after the daemon
> > > > > +starts
> > > > > next
> > > > > + * time, the obsolete data in fcopy_transaction.message or
> > > > > + * fcopy_transaction.fcopy_msg will be used immediately.
> > > > > + */
> > > > > +if (down_trylock(&fcopy_transaction.read_sema))
> > > > > +pr_debug("FCP: failed to acquire the semaphore\n");
> > > > > +
> > > > >  }
> > > >
> > > > When the daemon is killed, we currently reset the state in the
> > > > release function. Why can't we cleanup the semaphore state
> > > > (initialize) here as
> > > well.
> > > >
> > > > K. Y
> > >
> > > Hi KY,
> > > 1) The down_trylock() here is necessary: the daemon can fail to
> > > respond
> > in 5
> > > seconds due to many reasons, e.g., the VM's CPU and I/O are too
> > > busy. In this case, the daemon may become running later(NOTE: in
> > > this example,
> > the
> > > daemon is not killed), but from the host user's point of view, the
> > PowerShell
> > > copy-vmfile command has failed, so here we have to 'down' the
> > semaphore
> > > anyway, otherwise, the daemon can get obsolete data.
> > >
> > > 2) If we add a line
> > > sema_init(&fcopy_transaction.read_sema, 0); in fcopy_release(), it
> > > seems OK at a glance, but we have to handle the race
> > > condition: the above down_trylock() and the sema_init() can, in
> > > theory,
> > run
> > > simultaneously on different virtual CPUs.  It's tricky to address this.
> > >
> > > 3) So I think we can reuse the same semaphore without an actually
> > > unnecessary re-initialization. :-)
> >
> > Agreed; you may want to get rid of the pr_debug() call though.
> >
> > Thanks,
> >
> > K. Y
> 
> The pr_debug() is added intentionally according to suggestion of Redhat's
> Vitaly Kuznetsov in the bugzilla:
> https://bugzilla.redhat.com/show_bug.cgi?id=1162100#c5
> 
> The function is declared with__must_check in include/linux/semaphore.h:
> extern int __must_check down_trylock(struct semaphore *sem);
> 
> Without checking the return value, we'll get these warning if the "Kernel
> hacking" options are enabled:
> 
> drivers/hv/hv_fcopy.c: In function 'fcopy_work_func':
> drivers/hv/hv_fcopy.c:95:2: warning: ignoring return value of 'down_trylock',
> declared with attribute warn_unused_result [-Wunused-result]
>   (void)down_trylock(&fcopy_transaction.read_sema);
>   ^
> 
> In practice, the message I add should be very rare since it's very unlikely to
> fail to get the semaphore in this timeout case -- and in case this happens, it's
> actually OK, because the driver has told the host user the PowerShell
> command should fail.
Clearly, we don't want to ignore the return value (to avoid the warning); but that does not mean
that we need to print a message that is of questionable value. That said, I am fine with the code that
you currently have as this message is going to be very rare.

Regards,

K. Y 
> 
> Thanks,
> -- Dexuan

