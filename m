Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab3HVOpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 10:45:53 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:39731 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457Ab3HVOpv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 10:45:51 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@elte.hu" <mingo@elte.hu>, "bp@alien8.de" <bp@alien8.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "fdeslaur@gmail.com" <fdeslaur@gmail.com>,
        "raphael.beamonte@gmail.com" <raphael.beamonte@gmail.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Tomoki Sekiyama <tomoki.sekiyama@hds.com>
Subject: RE: [RFC][PATCH] Introduce page fault tracepoint
Thread-Topic: [RFC][PATCH] Introduce page fault tracepoint
Thread-Index: AQHOjXd/Nr57tj4uokq9RJ5sBLQXp5mhrFyA///CJLA=
Date: Thu, 22 Aug 2013 14:44:58 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D443E8E677@USINDEM103.corp.hds.com>
References: <51F843B1.4050609@hds.com>
 <20130822101557.2a6efae0@gandalf.local.home>
In-Reply-To: <20130822101557.2a6efae0@gandalf.local.home>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.73.11]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:207.126.244.0/26 ip4:207.126.252.0/25 include:mktomail.com
 include:cloud.hds.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-08-22_06:2013-08-22,2013-08-22,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1308220088
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Printing the regs pointer is rather useless. This is specific for x86,
> why not print the ip of where it happened and the faulting address
> itself?

Thank you for reviewing.
I will change the regs pointer to ip.

> Note, you only need to change the TP_printk() to do that. For
> efficiency reasons, only pass in regs.
 
OK. Will change the TP_printk().

Seiji
