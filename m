Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757639Ab3BRXqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 18:46:52 -0500
Received: from usindpps03.hds.com ([207.126.252.16]:56292 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756671Ab3BRXqu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 18:46:50 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Steven Rostedt <rostedt@goodmis.org>, "H. Peter Anvin" <hpa@zytor.com>
CC: "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Thomas Gleixner (tglx@linutronix.de)" <tglx@linutronix.de>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "Borislav Petkov (bp@alien8.de)" <bp@alien8.de>,
        Satoru Moriya <satoru.moriya@hds.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>
Subject: RE: [PATCH v9 2/3] trace,x86: add x86 irq vector tracepoints
Thread-Topic: [PATCH v9 2/3] trace,x86: add x86 irq vector tracepoints
Thread-Index: Ac4DKenvaw7irpCHQuCAh5bLR9M+cAI2fG6AAAPXLoAAAGoYgAAAYjMAAIaQEGA=
Date: Mon, 18 Feb 2013 23:45:58 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D414ABE178@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A64C4B@USINDEM103.corp.hds.com>
	  <511ECE53.8040801@zytor.com>
	 <1360979993.23152.122.camel@gandalf.local.home>
	 <511EEAE1.1040106@zytor.com> <1360981364.23152.123.camel@gandalf.local.home>
In-Reply-To: <1360981364.23152.123.camel@gandalf.local.home>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.73.11]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2013-02-18_05:2013-02-18,2013-02-18,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1211240000
 definitions=main-1302180267
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Not-yet-signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> >
> > ... so I was holding off on doing anything with it.
> 
> Heh, and I was waiting for comments from you before doing anything further with it ;-)
> 
> Email review deadlock!

So, how do you plan to push ahead with this patch?

https://lkml.org/lkml/2013/2/1/532

<snip>
I think I got all the cases, as NMIs causes the store/restore functions to be re-entrent without any locks.
<snip>

Steven, 
if you think you got all the cases, you can do more testing.
What is your concern?

I hope this patch will be included in 3.9.

Seiji



