Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111AbaLAPzB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 10:55:01 -0500
Received: from mail-bl2on0104.outbound.protection.outlook.com ([65.55.169.104]:47664
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753864AbaLAPy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 10:54:59 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Dexuan Cui <decui@microsoft.com>, Jason Wang <jasowang@redhat.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH v3] hv: hv_fcopy: drop the obsolete message on transfer
 failure
Thread-Topic: [PATCH v3] hv: hv_fcopy: drop the obsolete message on transfer
 failure
Thread-Index: AQHQDVAjSzw/zQ+dsEi8PDH7zIFezJx6kYOAgABR5rA=
Date: Mon, 1 Dec 2014 15:54:55 +0000
Message-ID: <BY2PR0301MB0711B72633E429F8F33F8871A07D0@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1417093747-21073-1-git-send-email-decui@microsoft.com>
	<1417157243.3268.1@smtp.corp.redhat.com>
	<F792CF86EFE20D4AB8064279AFBA51C613E66566@HKNPRD3002MB017.064d.mgd.msft.net>
	<1417169573.5822.12@smtp.corp.redhat.com>
	<F792CF86EFE20D4AB8064279AFBA51C613E66AAA@HKNPRD3002MB017.064d.mgd.msft.net>
	<1417422163.877.1@smtp.corp.redhat.com>
	<F792CF86EFE20D4AB8064279AFBA51C613E691B8@HKNPRD3002MB017.064d.mgd.msft.net>
 <1417429104.4907.0@smtp.corp.redhat.com>
 <F792CF86EFE20D4AB8064279AFBA51C613E69318@HKNPRD3002MB017.064d.mgd.msft.net>
In-Reply-To: <F792CF86EFE20D4AB8064279AFBA51C613E69318@HKNPRD3002MB017.064d.mgd.msft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.107.192.212]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0712;UriScan:;
x-o365ent-eop-header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0712;
x-forefront-prvs: 0412A98A59
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(377454003)(189002)(13464003)(51704005)(24454002)(2561002)(2421001)(76176999)(86612001)(86362001)(76576001)(77096004)(20776003)(551934003)(99286002)(74316001)(19580395003)(62966003)(77156002)(92726001)(106356001)(95666004)(15975445006)(19580405001)(92566001)(107046002)(106116001)(54606007)(50986999)(54356999)(105586002)(31966008)(66066001)(217423001)(40100003)(93886004)(122556002)(101416001)(21056001)(87936001)(2656002)(64706001)(33656002)(99396003)(120916001)(1511001)(46102003)(4396001)(97736003)(54206007);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0712;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0661;
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sB1FtCok010194



> -----Original Message-----
> From: Dexuan Cui
> Sent: Monday, December 1, 2014 3:01 AM
> To: Jason Wang
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com; KY
> Srinivasan; vkuznets@redhat.com; Haiyang Zhang
> Subject: RE: [PATCH v3] hv: hv_fcopy: drop the obsolete message on transfer
> failure
> 
> > -----Original Message-----
> > From: Jason Wang [mailto:jasowang@redhat.com]
> > Sent: Monday, December 1, 2014 18:18 PM
> > To: Dexuan Cui
> > Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > driverdev- devel@linuxdriverproject.org; olaf@aepfle.de;
> > apw@canonical.com; KY Srinivasan; vkuznets@redhat.com; Haiyang Zhang
> > Subject: RE: [PATCH v3] hv: hv_fcopy: drop the obsolete message on
> > transfer failure
> >
> >
> >
> > On Mon, Dec 1, 2014 at 5:47 PM, Dexuan Cui <decui@microsoft.com>
> wrote:
> > >>  -----Original Message-----
> > >>  From: Jason Wang [mailto:jasowang@redhat.com]
> > >>  Sent: Monday, December 1, 2014 16:23 PM
> > >>  To: Dexuan Cui
> > >>  Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > >> driverdev-
> > >>  devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> > >> KY  Srinivasan; vkuznets@redhat.com; Haiyang Zhang
> > >>  Subject: RE: [PATCH v3] hv: hv_fcopy: drop the obsolete message on
> > >> transfer  failure  On Fri, Nov 28, 2014 at 7:54 PM, Dexuan Cui
> > >> <decui@microsoft.com>
> > >> wrote:
> > >>  >>  -----Original Message-----
> > >>  >>  From: Jason Wang [mailto:jasowang@redhat.com]  >>  Sent:
> > >> Friday, November 28, 2014 18:13 PM  >>  To: Dexuan Cui  >>  Cc:
> > >> gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;  >>
> > >> driverdev-  >>  devel@linuxdriverproject.org; olaf@aepfle.de;
> > >> apw@canonical.com; KY  >>  Srinivasan; vkuznets@redhat.com; Haiyang
> > >> Zhang  >>  Subject: RE: [PATCH v3] hv: hv_fcopy: drop the obsolete
> > >> message on  >> transfer  >>  failure  >>  On Fri, Nov 28, 2014 at
> > >> 4:36 PM, Dexuan Cui <decui@microsoft.com>  >> wrote:
> > >>  >>  >>  -----Original Message-----  >>  >>  From: Jason Wang
> > >> [mailto:jasowang@redhat.com]  >>  >>  Sent: Friday, November 28,
> > >> 2014 14:47 PM  >>  >>  To: Dexuan Cui  >>  >>  Cc:
> > >> gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;  >>  >>
> > >> driverdev-  >>  >>  devel@linuxdriverproject.org; olaf@aepfle.de;
> > >> >> apw@canonical.com; KY  >>  >>  Srinivasan; vkuznets@redhat.com;
> > >> Haiyang Zhang  >>  >>  Subject: Re: [PATCH v3] hv: hv_fcopy: drop
> > >> the obsolete message  >> on  >>  >> transfer  >>  >>  failure  >>
> > >> >>  On Thu, Nov 27, 2014 at 9:09 PM, Dexuan Cui  >>
> > >> <decui@microsoft.com>  >>  >> wrote:
> > >>  >>  >>  > In the case the user-space daemon crashes, hangs or is
> > >> >> killed, we  >>  >>  > need to down the semaphore, otherwise,
> > >> after the daemon starts  >>  >> next  >>  >>  > time, the obsolete
> > >> data in fcopy_transaction.message or  >>  >>  >
> > >> fcopy_transaction.fcopy_msg will be used immediately.
> > >>  >>  >>  >
> > >>  >>  >>  > Cc: Jason Wang <jasowang@redhat.com>  >>  >>  > Cc:
> > >> Vitaly Kuznetsov <vkuznets@redhat.com>  >>  >>  > Cc: K. Y.
> > >> Srinivasan <kys@microsoft.com>  >>  >>  > Signed-off-by: Dexuan Cui
> > >> <decui@microsoft.com>  >>  >>  > ---  >>  >>  >  >>  >>  > v2: I
> > >> removed the "FCP" prefix as Greg asked.
> > >>  >>  >>  >
> > >>  >>  >>  >     I also updated the output message a little:
> > >>  >>  >>  >     "FCP: failed to acquire the semaphore" -->
> > >>  >>  >>  >     "can not acquire the semaphore: it is benign"
> > >>  >>  >>  >
> > >>  >>  >>  > v3: I added the code in fcopy_release() as Jason Wang
> > >> >> suggested.
> > >>  >>  >>  >     I removed the pr_debug (it isn't so meaningful)and
> > >> added a
> > >>  >>  >>  > comment instead.
> > >>  >>  >>  >
> > >>  >>  >>  >  drivers/hv/hv_fcopy.c | 19 +++++++++++++++++++  >>  >>
> > >> >  1 file changed, 19 insertions(+)  >>  >>  >  >>  >>  > diff
> > >> --git a/drivers/hv/hv_fcopy.c b/drivers/hv/hv_fcopy.c  >>  >>  >
> > >> index 23b2ce2..faa6ba6 100644  >>  >>  > ---
> > >> a/drivers/hv/hv_fcopy.c  >>  >>  > +++ b/drivers/hv/hv_fcopy.c  >>
> > >> >>  > @@ -86,6 +86,18 @@ static void fcopy_work_func(struct  >>
> > >> work_struct  >>  >>  > *dummy)
> > >>  >>  >>  >  	 * process the pending transaction.
> > >>  >>  >>  >  	 */
> > >>  >>  >>  >  	fcopy_respond_to_host(HV_E_FAIL);
> > >>  >>  >>  > +
> > >>  >>  >>  > +	/* In the case the user-space daemon crashes, hangs
> or
> > >> is
> > >>  >>  >> killed, we
> > >>  >>  >>  > +	 * need to down the semaphore, otherwise, after
> the
> > >> daemon
> > >>  >>  >> starts
> > >>  >>  >>  > next
> > >>  >>  >>  > +	 * time, the obsolete data in
> fcopy_transaction.message
> > >> or
> > >>  >>  >>  > +	 * fcopy_transaction.fcopy_msg will be used
> immediately.
> > >>  >>  >>  > +	 *
> > >>  >>  >>  > +	 * NOTE: fcopy_read() happens to get the
> semaphore (very
> > >>  >> rare)?
> > >>  >>  >>  > We're
> > >>  >>  >>  > +	 * still OK, because we've reported the failure to the
> > >> host.
> > >>  >>  >>  > +	 */
> > >>  >>  >>  > +	if (down_trylock(&fcopy_transaction.read_sema))
> > >>  >>  >>  > +		;
> > >>  >>  >>
> > >>  >>  >>  Sorry, I'm not quite understand how if () ; can help here.
> > >>  >>  >>
> > >>  >>  >>  Btw, a question not relate to this patch.
> > >>  >>  >>
> > >>  >>  >>  What happens if a daemon is resume from SIGSTOP and
> > >> expires the  >>  >> check  >>  >>  here?
> > >>  >>  > Hi Jason,
> > >>  >>  > My idea is: here we need down_trylock(), but in case we
> > >> can't get  >> the  >>  > semaphore, it's OK anyway:
> > >>  >>  >
> > >>  >>  > Scenario 1):
> > >>  >>  > 1.1: when the daemon is blocked on the pread(), the daemon
> > >> >> receives  >>  > SIGSTOP;  >>  > 1.2: the host user runs the
> > >> PowerShell Copy-VMFile command;  >>  > 1.3.1: the driver reports
> > >> the failure to the host user in 5s and  >>  > 1.3.2: the driver
> > >> down()-es the semaphore;  >>  > 1.4: the daemon receives SIGCONT
> > >> and it will be still blocked on  >> the  >>  > pread().
> > >>  >>  > Without the down_trylock(), in 1.4, the daemon can receive
> > >> an  >>  > obsolete message.
> > >>  >>  > NOTE: in this scenario, the daemon is not killed.
> > >>  >>  >
> > >>  >>  > Scenario 2):
> > >>  >>  > In senario 1), if the daemon receives SIGCONT between 1.3.1
> > >> and  >> 1.3.2  >>  > and  >>  > do down() in fcopy_read(), it will
> > >> receive the message but:
> > >> the
> > >>  >>  > driver has
> > >>  >>  > reported the failure to the host user and the driver's 1.3.2
> > >> can't  >>  > get the  >>  > semaphore -- IMO this is acceptably OK,
> > >> though in the VM, an  >>  > incomplete  >>  > file will be left
> > >> there.
> > >>  >>  > BTW, I think in the daemon's hv_start_fcopy() we should add
> > >> a  >>  > close(target_fd) before open()-ing a new one.
> > >>  >>
> > >>  >>  Right, but how about the case when resuming from SIGSTOP but
> > >> no  >> timeout?
> > >>  > Sorry, I don't understand this:
> > >>  > if no timeout, fcopy_read() will get the semaphore and
> > >> fcopy_write()
> > >>  > will try to cancel fcopy_work.
> > >>
> > >>  Yes.
> > >>  >
> > >>  >
> > >>  >>  Looks like in this case userspace() may wait in
> > >> down_interruptible()
> > >>  >>  until timeout. We probably need something like this:
> > >>  >>
> > >>  >>          if (down_interruptible(&fcopy_transaction.read_sema)) {
> > >>  >>                  up(&fcopy_transaction.read_sema);
> > >>  >>                  return -EINTR;
> > >>  >>          }
> > >>  > until "timeout"?
> > >>  > if the daemon can't get the semaphore, it can only be wake by a
> > >> > signal(the  > daemon doesn't install handler, so by default most
> > >> signals will kill  > the daemon).
> > >>  > In case a signal waking up the daemon doesn't kill the daemon,
> > >> why  > should  > we do up()?
> > >>
> > >>  True, no need since we do down_trylock() in release().
> > >>
> > >>  Btw, there's no EINTR handling in handling pread() return value,
> > >> may add such one which should be useful for something like
> > >> debugging.
> > >>
> > >>  >
> > >>  >
> > >>  >>
> > >>  >>  This should synchronize with the timeout work for sure.
> > >>  >>  But how about only schedule it after this?
> > >>  >>  It does not may sense to start the timer during interrupt  >>
> > >> since the file may not even opened and it may take time  >>  to
> > >> handle signals?
> > >>  >>
> > >>  >>  >
> > >>  >>  >>  >
> > >>  >>  >>  > +
> > >>  >>  >>  >  }
> > >>  >>  >>  >
> > >>  >>  >>  >  static int fcopy_handle_handshake(u32 version)  >>  >>
> > >> > @@ -351,6 +363,13 @@ static int fcopy_release(struct inode  >>
> > >> *inode,  >>  >>  > struct file *f)
> > >>  >>  >>  >  	 */
> > >>  >>  >>  >  	in_hand_shake = true;
> > >>  >>  >>  >  	opened = false;
> > >>  >>  >>  > +
> > >>  >>  >>  > +	if (cancel_delayed_work_sync(&fcopy_work)) {
> > >>  >>  >>  > +		/* We haven't up()-ed the semaphore(very
> rare)? */
> > >>  >>  >>  > +		if
> (down_trylock(&fcopy_transaction.read_sema))
> > >>  >>  >>  > +			;
> > >>  >>  >>
> > >>  >>  >>  And this.
> > >>  >>  >
> > >>  >>  > Scenario 3):
> > >>  >>  > When the daemon exits(e.g., SIGKILL received), if there is a
> > >> >>  > fcopy_work  >>  > pending (scheduled but not start to run
> > >> yet), we should cancel the  >>  > work (as you suggested) and
> > >> down() the semaphore, otherwise, the  >>  > obsolete message will
> > >> be received by the next instance of the  >> daemon.
> > >>  >>
> > >>  >>  Yes
> > >>  >>  >
> > >>  >>  >
> > >>  >>  > Scenario 4):  in the driver's hv_fcopy_onchannelcallback():
> > >>  >>  >         schedule_delayed_work(&fcopy_work, 5*HZ);
> > >>  >>  >         ----> if fcopy_release() is running on another vcpu,
> > >> just
> > >>  >>  > before the next line?
> > >>  >>  >         fcopy_send_data();
> > >>  >>  >
> > >>  >>  > In this case, fcopy_release() can cancel fcopy_work, but  >>
> > >> > can't get the semaphore since it hasn't been up()-ed.
> > >>  >>  > Hmm, in this case,   fcopy_send_data() will do up()  later,
> > >> and
> > >>  >> we'll
> > >>  >>  > buffer an obsolete message in the driver, and the message
> > >> will be  >>  > fetched by the next instance of the daemon...
> > >>  >>  >
> > >>  >>  > Looks we need a spinlock here?
> > >>  >>
> > >>  >>  Unless fcopy_release() can wait for all data for current
> > >> transation  >>  to be received. Spinlock won't help.
> > >>  >>
> > >>  >>  But an idea is let the daemon the handle such cases. E.g make
> > >> sure  >> the  >>  processing begins with START_COPY and end with
> > >> COMPLETE/CANCEL_COPY.
> > >>  >>  Drop all requests that does not start with START_COPY.
> > >>  >>
> > >>  >>  Thought?
> > >>  > Good idea.
> > >>  > I also think we should reinforce the concept of state machine in
> > >> the  > daemon code.
> > >>
> > >>  Yes, it needs.
> > > I agree.
> > > Obviously we can do something to make the daemon/driver work better
> > > in the corner cases.
> > >
> > >>  >
> > >>  > The daemon/driver communication has so many corner cases...
> > >>
> > >>  Looks so, let's first address the issue mentioned in this patch.
> > > OK.
> > >
> > >>  I don't have any more comments other than changing
> > >>
> > >>   if(down_trylock(&fcopy_transaction.read_sema))
> > >>       ;
> > >>
> > >>  to
> > >>
> > >>  down_trylock(&fcopy_transaction.read_sema);
> > > Hi Jason,
> > > This is to address Vitaly's comment in the bugzilla:
> > > https://bugzilla.redhat.com/show_bug.cgi?id=1162100#c5
> > >
> > > down_trylock(&fcopy_transaction.read_sema) will
> > >
> > > "
> > > produces the following compile warning:
> > > drivers/hv/hv_fcopy.c: In function â€˜fcopy_work_funcâ€™:
> > > drivers/hv/hv_fcopy.c:95:2: warning: ignoring return value of
> > > â€˜down_trylockâ€™, declared with attribute warn_unused_result
> > > [-Wunused-result]
> > >   (void)down_trylock(&fcopy_transaction.read_sema);
> > > "
> > >
> > > Actually I personally don't care about the warning, because we only
> > > see it when we run some kind of code checker program.  :-)
> > >
> > > I can change my v3  to the "normal" style you prefer, if there is no
> > > strong objection from Vitaly?
> >
> > Ah, I see the point. Then no objection for this patch.
> >
> > Since Vitaly said he does not has objection.
> >
> > Acked-by: Jason Wang <jasowang@redhat.com>
> 
> I realized non-trivial effort might be needed to better handle corner cases.
> This is only the first step.
> 
> E.g., I found a new corner case:
> after we unload the hv_utils/fcopy driver, the fcopy daemon can exit and
> fcopy_release() will be invoked -- at this time fcopy_release() has become
> obsolete and invalid, and as a result, a kernel panic can happen:  I did see the
> panic once.

You should not be able to unload the driver when there is still an open reference from the
Daemon.

K. Y
> 
> -- Dexuan

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
