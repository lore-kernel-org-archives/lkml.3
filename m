Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751003Ab3AVFCK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 00:02:10 -0500
Received: from myspam1.stec-inc.com ([210.19.18.169]:59123 "HELO
	mysmtp1.stec-inc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750738Ab3AVFCH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 00:02:07 -0500
X-ASG-Debug-ID: 1358830922-053ea90dcf1c5780001-xx1T2L
X-Barracuda-Envelope-From: akale@stec-inc.com
X-Barracuda-RBL-Trusted-Forwarder: 172.30.0.57
From: Amit Kale <akale@stec-inc.com>
X-Barracuda-BWL-IP: fe80::64e7:ed5b:e6f9:c391
X-Barracuda-Apparent-Source-IP: fe80::64e7:ed5b:e6f9:c391
To: Mike Snitzer <snitzer@redhat.com>
CC: "Darrick J. Wong" <darrick.wong@oracle.com>,
        device-mapper development <dm-devel@redhat.com>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "lsf-pc@lists.linux-foundation.org" 
	<lsf-pc@lists.linux-foundation.org>,
        Joe Thornber <ejt@redhat.com>
Date: Tue, 22 Jan 2013 13:00:35 +0800
Subject: RE: [LSF/MM TOPIC] Re: [dm-devel] Announcement: STEC EnhanceIO SSD
 caching software for Linux kernel
Thread-Topic: [LSF/MM TOPIC] Re: [dm-devel] Announcement: STEC EnhanceIO SSD
 caching software for Linux kernel
X-ASG-Orig-Subj: RE: [LSF/MM TOPIC] Re: [dm-devel] Announcement: STEC EnhanceIO SSD
 caching software for Linux kernel
Thread-Index: Ac332HwK2naQVTMqQ+Go/ZRfaUqFMAAhLyIQ
Message-ID: <C4B5704C6FEB5244B2A1BCC8CF83B86B0A624D5DFC@MYMBX.MY.STEC-INC.AD>
References: <50F844A3.9020300@warr.net>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D72F1@MYMBX.MY.STEC-INC.AD>
 <50F970A3.4000403@warr.net> <20130118161135.GA3118@raspberrypi>
 <50F97C0F.9010405@warr.net>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D7345@MYMBX.MY.STEC-INC.AD>
 <50F9963A.2080608@warr.net> <20130118212543.GB6425@blackbox.djwong.org>
 <20130118213759.GA30278@redhat.com>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B0A624D5D4D@MYMBX.MY.STEC-INC.AD>
 <20130121130951.GA16574@redhat.com>
In-Reply-To: <20130121130951.GA16574@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Barracuda-Connect: mycas01.my.stec-inc.ad[172.30.0.57]
X-Barracuda-Start-Time: 1358830922
X-Barracuda-URL: http://myspam1.stec-inc.com:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.120547
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Mike Snitzer [mailto:snitzer@redhat.com]
> Sent: Monday, January 21, 2013 6:40 PM
> To: Amit Kale
> Cc: Darrick J. Wong; device-mapper development; linux-
> bcache@vger.kernel.org; kent.overstreet@gmail.com; LKML; lsf-
> pc@lists.linux-foundation.org; Joe Thornber
> Subject: Re: [LSF/MM TOPIC] Re: [dm-devel] Announcement: STEC EnhanceIO
> SSD caching software for Linux kernel
> 
> On Mon, Jan 21 2013 at 12:26am -0500,
> Amit Kale <akale@stec-inc.com> wrote:
> 
> > > -----Original Message-----
> > > From: Mike Snitzer [mailto:snitzer@redhat.com]
> > > Sent: Saturday, January 19, 2013 3:08 AM
> > > To: Darrick J. Wong
> > > Cc: device-mapper development; Amit Kale;
> > > linux-bcache@vger.kernel.org; kent.overstreet@gmail.com; LKML;
> > > lsf-pc@lists.linux-foundation.org; Joe Thornber
> > > Subject: Re: [LSF/MM TOPIC] Re: [dm-devel] Announcement: STEC
> > > EnhanceIO SSD caching software for Linux kernel
> > >
> > > On Fri, Jan 18 2013 at  4:25pm -0500, Darrick J. Wong
> > > <darrick.wong@oracle.com> wrote:
> > >
> > > > Since Joe is putting together a testing tree to compare the three
> > > > caching things, what do you all think of having a(nother) session
> > > > about ssd caching at this year's LSFMM Summit?
> > > >
> > > > [Apologies for hijacking the thread.] [Adding lsf-pc to the cc
> > > > list.]
> > >
> > > Hopefully we'll have some findings on the comparisons well before
> > > LSF (since we currently have some momentum).  But yes it may be
> > > worthwhile to discuss things further and/or report findings.
> >
> > We should have performance comparisons presented well before the
> > summit. It'll be good to have ssd caching session in any case. The
> > likelihood that one of them will be included in Linux kernel before
> > April is very low.
> 
> dm-cache is under active review for upstream inclusion.  I wouldn't
> categorize the chances of dm-cache going upstream when the v3.9 merge
> window opens as "very low".  But even if dm-cache does go upstream it
> doesn't preclude bcache and/or enhanceio from going upstream too.

I agree. We haven't seen a full comparison yet, IMHO. If different solutions offer mutually exclusive benefits, it'll be worthwhile including them all.

We haven't submitted EnhanceIO for an inclusion yet. Need more testing from the community before we can mark it Beta.
-Amit

PROPRIETARY-CONFIDENTIAL INFORMATION INCLUDED



This electronic transmission, and any documents attached hereto, may contain confidential, proprietary and/or legally privileged information. The information is intended only for use by the recipient named above. If you received this electronic message in error, please notify the sender and delete the electronic message. Any disclosure, copying, distribution, or use of the contents of information received in error is strictly prohibited, and violators will be pursued legally.
