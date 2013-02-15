Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935722Ab3BOKid (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 05:38:33 -0500
Received: from mysmtp1.stec-inc.com ([1.9.68.9]:37968 "HELO
	mysmtp1.stec-inc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760476Ab3BOKib convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 05:38:31 -0500
X-ASG-Debug-ID: 1360924708-053ea90dcf2a5390001-xx1T2L
X-Barracuda-Envelope-From: akale@stec-inc.com
X-Barracuda-RBL-Trusted-Forwarder: 172.30.0.57
From: Amit Kale <akale@stec-inc.com>
X-Barracuda-BWL-IP: fe80::64e7:ed5b:e6f9:c391
X-Barracuda-Apparent-Source-IP: fe80::64e7:ed5b:e6f9:c391
To: Jens Axboe <axboe@kernel.dk>, OS Engineering <osengineering@stec-inc.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Sanoj Unnikrishnan <sunnikrishnan@stec-inc.com>,
        =?iso-2022-jp?B?GyRCMiY2YjE6GyhC?= <jinpuwang@gmail.com>
Date: Fri, 15 Feb 2013 18:36:31 +0800
Subject: RE: [PATCH] EnhanceIO ssd caching software
Thread-Topic: [PATCH] EnhanceIO ssd caching software
X-ASG-Orig-Subj: RE: [PATCH] EnhanceIO ssd caching software
Thread-Index: Ac4LXxNOC4F30gYeR0upzZqq43p0pgACQ1GA
Message-ID: <C4B5704C6FEB5244B2A1BCC8CF83B86B0A624D6ADE@MYMBX.MY.STEC-INC.AD>
References: <C4B5704C6FEB5244B2A1BCC8CF83B86B0A624D6AAF@MYMBX.MY.STEC-INC.AD>
 <20130215092955.GY21269@kernel.dk>
In-Reply-To: <20130215092955.GY21269@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Barracuda-Connect: mycas01.my.stec-inc.ad[172.30.0.57]
X-Barracuda-Start-Time: 1360924708
X-Barracuda-URL: http://myspam1.stec-inc.com:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: -0.00
X-Barracuda-Spam-Status: No, SCORE=-0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=ISO2022JP_CHARSET
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.122731
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	-0.00 ISO2022JP_CHARSET      ISO-2022-JP message
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Jens Axboe
> Sent: Friday, February 15, 2013 3:00 PM
> To: OS Engineering
> Cc: Greg Kroah-Hartman; LKML; Darrick J. Wong; Sanoj Unnikrishnan;
> 王金浦; Amit Kale
> Subject: Re: [PATCH] EnhanceIO ssd caching software
> 
> On Fri, Feb 15 2013, OS Engineering wrote:
> > Hi Greg, Jens,
> >
> > We are submitting EnhanceIO(TM) software driver for an inclusion in
> > linux staging tree. Present state of this driver is beta. We have
> been
> > posting it for a few weeks, while it was maintained at github. It is
> > still being cleaned-up and is being tested by LKML members. Inclusion
> > in linux staging tree will make testing and reviewing easier and help
> > a future integration in Linux kernel.
> 
> From a quick look, this looks clean enough to not warrant a stop in
> staging. Why don't we just queue it up for 3.10, that will give it 3-4
> months before it hits a release kernel. So plenty of time to iron out
> any kinks in this. It's a driver and completely isolated at that, so
> I'd have no problem doing that.

That'll be great. A few more clean-ups are remaining. It's undergone extensive in-house testing in last few months, so I am hoping that we'll not see any bug reports.

Let's queue it for 3.10.

Thanks a lot.
-Amit


> 
> --
> Jens Axboe
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> in the body of a message to majordomo@vger.kernel.org More majordomo
> info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

PROPRIETARY-CONFIDENTIAL INFORMATION INCLUDED



This electronic transmission, and any documents attached hereto, may contain confidential, proprietary and/or legally privileged information. The information is intended only for use by the recipient named above. If you received this electronic message in error, please notify the sender and delete the electronic message. Any disclosure, copying, distribution, or use of the contents of information received in error is strictly prohibited, and violators will be pursued legally.
