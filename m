Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935386Ab3BOGJD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 01:09:03 -0500
Received: from mysmtp1.stec-inc.com ([1.9.68.9]:35595 "HELO
	mysmtp1.stec-inc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751824Ab3BOGJB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 01:09:01 -0500
X-ASG-Debug-ID: 1360908538-053ea90dcf2a3770001-xx1T2L
X-Barracuda-Envelope-From: akale@stec-inc.com
X-Barracuda-RBL-Trusted-Forwarder: 172.30.0.57
From: Amit Kale <akale@stec-inc.com>
X-Barracuda-BWL-IP: fe80::64e7:ed5b:e6f9:c391
X-Barracuda-Apparent-Source-IP: fe80::64e7:ed5b:e6f9:c391
To: OS Engineering <osengineering@stec-inc.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
CC: "Darrick J. Wong" <darrick.wong@oracle.com>,
        Sanoj Unnikrishnan <sunnikrishnan@stec-inc.com>,
        =?iso-2022-jp?B?GyRCMiY2YjE6GyhC?= <jinpuwang@gmail.com>,
        Kent Overstreet <koverstreet@google.com>,
        "thornber@redhat.com" <thornber@redhat.com>
Date: Fri, 15 Feb 2013 14:07:02 +0800
Subject: RE: [PATCH] EnhanceIO ssd caching software
Thread-Topic: [PATCH] EnhanceIO ssd caching software
X-ASG-Orig-Subj: RE: [PATCH] EnhanceIO ssd caching software
Thread-Index: Ac4LQg6V0G/eqmgQTNW5yvkgRC3plwAAIPdg
Message-ID: <C4B5704C6FEB5244B2A1BCC8CF83B86B0A624D6AB1@MYMBX.MY.STEC-INC.AD>
References: <C4B5704C6FEB5244B2A1BCC8CF83B86B0A624D6AAF@MYMBX.MY.STEC-INC.AD>
In-Reply-To: <C4B5704C6FEB5244B2A1BCC8CF83B86B0A624D6AAF@MYMBX.MY.STEC-INC.AD>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Barracuda-Connect: mycas01.my.stec-inc.ad[172.30.0.57]
X-Barracuda-Start-Time: 1360908538
X-Barracuda-URL: http://myspam1.stec-inc.com:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.01
X-Barracuda-Spam-Status: No, SCORE=0.01 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=BSF_SC0_SA_TO_FROM_DOMAIN_MATCH, ISO2022JP_CHARSET
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.122714
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	-0.00 ISO2022JP_CHARSET      ISO-2022-JP message
	0.01 BSF_SC0_SA_TO_FROM_DOMAIN_MATCH Sender Domain Matches Recipient
	                           Domain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Kent and Joe.
-Amit

> -----Original Message-----
> From: OS Engineering
> Sent: Friday, February 15, 2013 11:33 AM
> To: Greg Kroah-Hartman; LKML; Jens Axboe
> Cc: Darrick J. Wong; Sanoj Unnikrishnan; 王金浦; Amit Kale
> Subject: [PATCH] EnhanceIO ssd caching software
> 
> Hi Greg, Jens,
> 
> We are submitting EnhanceIO(TM) software driver for an inclusion in
> linux staging tree. Present state of this driver is beta. We have been
> posting it for a few weeks, while it was maintained at github. It is
> still being cleaned-up and is being tested by LKML members. Inclusion
> in linux staging tree will make testing and reviewing easier and help a
> future integration in Linux kernel.
> 
> Could you please include it?
> 
> Thanks.
> --
> Amit Kale

PROPRIETARY-CONFIDENTIAL INFORMATION INCLUDED



This electronic transmission, and any documents attached hereto, may contain confidential, proprietary and/or legally privileged information. The information is intended only for use by the recipient named above. If you received this electronic message in error, please notify the sender and delete the electronic message. Any disclosure, copying, distribution, or use of the contents of information received in error is strictly prohibited, and violators will be pursued legally.
