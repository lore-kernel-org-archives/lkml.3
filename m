Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508Ab3BBCpT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 21:45:19 -0500
Received: from [1.9.68.9] ([1.9.68.9]:39133 "HELO mysmtp1.stec-inc.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1757349Ab3BBCpQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 21:45:16 -0500
X-ASG-Debug-ID: 1359769715-053ea90dcf1ea900001-xx1T2L
X-Barracuda-Envelope-From: akale@stec-inc.com
X-Barracuda-RBL-Trusted-Forwarder: 172.30.0.57
From: Amit Kale <akale@stec-inc.com>
X-Barracuda-BWL-IP: fe80::64e7:ed5b:e6f9:c391
X-Barracuda-Apparent-Source-IP: fe80::64e7:ed5b:e6f9:c391
To: Kent Overstreet <koverstreet@google.com>,
        Michel Lespinasse <walken@google.com>
CC: "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-bcache <linux-bcache@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Jason Warr <jason@warr.net>,
        "thornber@redhat.com" <thornber@redhat.com>
Date: Sat, 2 Feb 2013 09:39:00 +0800
Subject: RE: [RFC] [DONOTAPPLY] [PATCH] enhanceio: STEC EnhanceIO SSD
 caching software for Linux kernel
Thread-Topic: [RFC] [DONOTAPPLY] [PATCH] enhanceio: STEC EnhanceIO SSD
 caching software for Linux kernel
X-ASG-Orig-Subj: RE: [RFC] [DONOTAPPLY] [PATCH] enhanceio: STEC EnhanceIO SSD
 caching software for Linux kernel
Thread-Index: Ac4A5AtW8U8rPT4hTq+3keiKLTHkEQAAfXbg
Message-ID: <C4B5704C6FEB5244B2A1BCC8CF83B86B0A624D6474@MYMBX.MY.STEC-INC.AD>
References: <20130202004459.GA4760@blackbox.djwong.org>
	<CANN689ExTyhZBiQ-pg3jw+sA4X459qcy3kpt82n3obJ=9AVceQ@mail.gmail.com>
	<CAH+dOxLDVsrmuh2b+RVxwOd0+JOQ+LsbuRYB5zqTE7DnoA+XTA@mail.gmail.com>
 <CAH+dOxKUdxF1Ds9ogncBF1K-A979j46SqGq1rVeqii8LtgHxQw@mail.gmail.com>
In-Reply-To: <CAH+dOxKUdxF1Ds9ogncBF1K-A979j46SqGq1rVeqii8LtgHxQw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Barracuda-Connect: mycas01.my.stec-inc.ad[172.30.0.57]
X-Barracuda-Start-Time: 1359769715
X-Barracuda-URL: http://myspam1.stec-inc.com:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.121558
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

End user documentation is on our github. I think it should go with the user level utilities, rather than the kernel driver.
-Amit

> -----Original Message-----
> From: Kent Overstreet [mailto:koverstreet@google.com]
> Sent: Friday, February 01, 2013 5:25 PM
> To: Michel Lespinasse
> Cc: Darrick J. Wong; Amit Kale; linux-bcache; device-mapper
> development; Kent Overstreet; Mike Snitzer; LKML; Jason Warr;
> thornber@redhat.com
> Subject: Re: [RFC] [DONOTAPPLY] [PATCH] enhanceio: STEC EnhanceIO SSD
> caching software for Linux kernel
> 
> Also, where's the end user documentation?
> 
> On Fri, Feb 1, 2013 at 5:23 PM, Kent Overstreet
> <koverstreet@google.com> wrote:
> > On Fri, Feb 1, 2013 at 4:57 PM, Michel Lespinasse <walken@google.com>
> wrote:
> >> On Fri, Feb 1, 2013 at 4:44 PM, Darrick J. Wong
> <darrick.wong@oracle.com> wrote:
> >>> This is a patch to migrate STEC's enhanceio driver out of their
> >>> github repository and into the staging tree.  From their README:
> >>>
> >>> "EnhanceIO driver is based on EnhanceIO SSD caching software
> product
> >>> developed by STEC Inc. EnhanceIO was derived from Facebook's open
> >>> source Flashcache project. EnhanceIO uses SSDs as cache devices for
> >>> traditional rotating hard disk drives (referred to as source
> volumes throughout this document).
> >>> EnhanceIO can work with any block device, be it an entire physical
> >>> disk, an individual disk partition,  a RAIDed DAS device, a SAN
> >>> volume, a device mapper volume or a software RAID (md) device."
> >>
> >> What's your take on the benefits of this vs bcache ?
> >
> > I've been trying to review it it for cache coherency and consistency
> > wrt. power failures, but the complete lack of high level
> documentation
> > is making that difficult.
> >
> > I saw some benchmarks the other day where on writes EIO was faster
> > than the raw device, which was... suspicious.

PROPRIETARY-CONFIDENTIAL INFORMATION INCLUDED



This electronic transmission, and any documents attached hereto, may contain confidential, proprietary and/or legally privileged information. The information is intended only for use by the recipient named above. If you received this electronic message in error, please notify the sender and delete the electronic message. Any disclosure, copying, distribution, or use of the contents of information received in error is strictly prohibited, and violators will be pursued legally.
