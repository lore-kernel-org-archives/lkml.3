Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924Ab3BAW2V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 17:28:21 -0500
Received: from usindpps06.hds.com ([207.126.252.19]:38791 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757724Ab3BAW2T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 17:28:19 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin (hpa@zytor.com)" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Thomas Gleixner (tglx@linutronix.de)" <tglx@linutronix.de>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "Borislav Petkov (bp@alien8.de)" <bp@alien8.de>,
        Satoru Moriya <satoru.moriya@hds.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>
Subject: RE: [RFC][PATCH v8 2/3] trace,x86: add x86 irq vector tracepoints
Thread-Topic: [RFC][PATCH v8 2/3] trace,x86: add x86 irq vector tracepoints
Thread-Index: Ac34JJMyFwTt3KidTvasHhLQsjVWNwIxO5IAAApzF3D//8CRAIAAULzg
Date: Fri, 1 Feb 2013 22:27:33 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D414A5F963@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A508CE@USINDEM103.corp.hds.com>
	 <1359752614.5642.49.camel@gandalf.local.home>
	 <A5ED84D3BB3A384992CBB9C77DEDA4D414A5F834@USINDEM103.corp.hds.com>
 <1359756944.5642.50.camel@gandalf.local.home>
In-Reply-To: <1359756944.5642.50.camel@gandalf.local.home>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.73.11]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2013-02-01_09:2013-02-01,2013-02-01,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1211240000
 definitions=main-1302010172
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Also, don't forget to add the mutex protection that I suggested in another email.

Will do. 
Thanks,

Seiji
