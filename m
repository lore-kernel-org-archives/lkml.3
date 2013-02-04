Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475Ab3BDQbs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 11:31:48 -0500
Received: from [1.9.68.9] ([1.9.68.9]:34008 "HELO mysmtp1.stec-inc.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1754348Ab3BDQbq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 11:31:46 -0500
X-ASG-Debug-ID: 1359995502-053ea90dcf20f280001-xx1T2L
X-Barracuda-Envelope-From: akale@stec-inc.com
X-Barracuda-RBL-Trusted-Forwarder: 172.30.0.57
From: Amit Kale <akale@stec-inc.com>
X-Barracuda-BWL-IP: fe80::64e7:ed5b:e6f9:c391
X-Barracuda-Apparent-Source-IP: fe80::64e7:ed5b:e6f9:c391
To: "thornber@redhat.com" <thornber@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
CC: linux-bcache <linux-bcache@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Jason Warr <jason@warr.net>
Date: Tue, 5 Feb 2013 00:30:03 +0800
Subject: RE: [RFC] [DONOTAPPLY] [PATCH] enhanceio: STEC EnhanceIO SSD
 caching software for Linux kernel
Thread-Topic: [RFC] [DONOTAPPLY] [PATCH] enhanceio: STEC EnhanceIO SSD
 caching software for Linux kernel
X-ASG-Orig-Subj: RE: [RFC] [DONOTAPPLY] [PATCH] enhanceio: STEC EnhanceIO SSD
 caching software for Linux kernel
Thread-Index: Ac4C5ZbzopoeJTLMS56bp7nneHE+NgADyu3A
Message-ID: <C4B5704C6FEB5244B2A1BCC8CF83B86B0A624D6542@MYMBX.MY.STEC-INC.AD>
References: <20130202004459.GA4760@blackbox.djwong.org>
 <20130204144016.GA2522@raspberrypi>
In-Reply-To: <20130204144016.GA2522@raspberrypi>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Barracuda-Connect: mycas01.my.stec-inc.ad[172.30.0.57]
X-Barracuda-Start-Time: 1359995502
X-Barracuda-URL: http://myspam1.stec-inc.com:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=BSF_SC0_MISMATCH_TO
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.121798
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.00 BSF_SC0_MISMATCH_TO    Envelope rcpt doesn't match header
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: thornber@redhat.com [mailto:thornber@redhat.com]
> Sent: Monday, February 04, 2013 6:40 AM
> To: Darrick J. Wong
> Cc: Amit Kale; linux-bcache; device-mapper development; Kent
> Overstreet; Mike Snitzer; LKML; Jason Warr
> Subject: Re: [RFC] [DONOTAPPLY] [PATCH] enhanceio: STEC EnhanceIO SSD
> caching software for Linux kernel
> 
> On Fri, Feb 01, 2013 at 04:44:59PM -0800, Darrick J. Wong wrote:
> > I will start reviewing the code as soon as this patch posts.  Be
> > warned that I haven't even compile tested this yet. :)
> 
> Has the code been updated since I looked at it a couple of weeks ago?
> For example addressing all the 'sparse' warnings?

Yes. Several warning were fixed and one kernel bug was fixed. It's better in terms of sparse warning, but not there yet.

-Amit

> 
> If you've not compiled or reviewed this code, what do you mean by the
> 'signed-off by' tag?
> 
> - Joe

PROPRIETARY-CONFIDENTIAL INFORMATION INCLUDED



This electronic transmission, and any documents attached hereto, may contain confidential, proprietary and/or legally privileged information. The information is intended only for use by the recipient named above. If you received this electronic message in error, please notify the sender and delete the electronic message. Any disclosure, copying, distribution, or use of the contents of information received in error is strictly prohibited, and violators will be pursued legally.
