Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab3ARRru (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 12:47:50 -0500
Received: from myspam1.stec-inc.com ([210.19.18.169]:49396 "HELO
	mysmtp1.stec-inc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751618Ab3ARRrs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 12:47:48 -0500
X-ASG-Debug-ID: 1358531264-053ea90dcf1bf720001-xx1T2L
X-Barracuda-Envelope-From: akale@stec-inc.com
X-Barracuda-RBL-Trusted-Forwarder: 172.30.0.57
From: Amit Kale <akale@stec-inc.com>
X-Barracuda-BWL-IP: fe80::64e7:ed5b:e6f9:c391
X-Barracuda-Apparent-Source-IP: fe80::64e7:ed5b:e6f9:c391
To: Jason Warr <jason@warr.net>,
        device-mapper development <dm-devel@redhat.com>,
        "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Date: Sat, 19 Jan 2013 01:44:30 +0800
Subject: RE: [dm-devel] Announcement: STEC EnhanceIO SSD caching software
 for Linux kernel
Thread-Topic: [dm-devel] Announcement: STEC EnhanceIO SSD caching software
 for Linux kernel
X-ASG-Orig-Subj: RE: [dm-devel] Announcement: STEC EnhanceIO SSD caching software
 for Linux kernel
Thread-Index: Ac31mwzTiVd9Of8oSEa/FpeEUoMuyAABufgw
Message-ID: <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D7345@MYMBX.MY.STEC-INC.AD>
References: <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D6F3C@MYMBX.MY.STEC-INC.AD>
 <CAMM=eLdgD8GKeK48SU2rfC49u3H4WRf9-xFxM4ymVPbKkx+mCw@mail.gmail.com>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D70CE@MYMBX.MY.STEC-INC.AD>
 <20130116104546.GA3869@raspberrypi>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D720A@MYMBX.MY.STEC-INC.AD>
 <20130117132620.GA2438@raspberrypi>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D7248@MYMBX.MY.STEC-INC.AD>
 <50F844A3.9020300@warr.net>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D72F1@MYMBX.MY.STEC-INC.AD>
 <50F970A3.4000403@warr.net> <20130118161135.GA3118@raspberrypi>
 <50F97C0F.9010405@warr.net>
In-Reply-To: <50F97C0F.9010405@warr.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Barracuda-Connect: mycas01.my.stec-inc.ad[172.30.0.57]
X-Barracuda-Start-Time: 1358531264
X-Barracuda-URL: http://myspam1.stec-inc.com:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.120219
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Jason Warr [mailto:jason@warr.net]
> Sent: Friday, January 18, 2013 10:15 PM
> To: Amit Kale; device-mapper development; kent.overstreet@gmail.com;
> Mike Snitzer; LKML; linux-bcache@vger.kernel.org
> Subject: Re: [dm-devel] Announcement: STEC EnhanceIO SSD caching
> software for Linux kernel
> 
> 
> On 01/18/2013 10:11 AM, thornber@redhat.com wrote:
> > On Fri, Jan 18, 2013 at 09:56:19AM -0600, Jason Warr wrote:
> >> If I can help test and benchmark all three of these solutions please
> >> ask.  I have allot of hardware resources available to me and perhaps
> >> I can add value from an outsiders perspective.
> > We'd love your help.  Perhaps you could devise a test that represents
> > how you'd use it?
> >
> > - Joe
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-bcache" in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> As much as I dislike Oracle that is one of my primary applications.  I
> am attempting to get one of my customers to setup an Oracle instance
> that is modular in that I can move the storage around to fit a
> particular hardware setup and have a consistent benchmark that they use
> in the real world to gauge performance.  One of them is a debit card
> transaction clearing entity on multi-TB databases so latency REALLY
> matters there.  

I am curious as to how SSD latency matters so much in the overall transaction times.

We do a lot of performance measurements using SQL database benchmarks. Transaction times vary a lot depending on location of data, complexity of the transaction etc. Typically TPM (transactions per minute) is of primary interest for TPC-C.

> Hopefully I'll have a couple of them setup within a
> week.  At that point I may need help in getting the proper kernel trees
> and patch sets munged into a working kernel.  That seems to be the spot
> where I fall over most of the time.
> 
> Unfortunately I probably could not share this specific setup but it is
> likely that I can derive a version from it that can be opened.

That'll be good. I'll check with our testing team whether they can run TPC-C comparisons for these three caching solutions.

-Amit

PROPRIETARY-CONFIDENTIAL INFORMATION INCLUDED



This electronic transmission, and any documents attached hereto, may contain confidential, proprietary and/or legally privileged information. The information is intended only for use by the recipient named above. If you received this electronic message in error, please notify the sender and delete the electronic message. Any disclosure, copying, distribution, or use of the contents of information received in error is strictly prohibited, and violators will be pursued legally.
