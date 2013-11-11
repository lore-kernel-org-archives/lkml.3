Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab3KKQJK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 11:09:10 -0500
Received: from usindpps04.hds.com ([207.126.252.17]:51491 "EHLO
	usindpps04.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab3KKQJD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 11:09:03 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>
CC: "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: RE: [tip:x86/trace] x86, trace: Add page fault tracepoints
Thread-Topic: [tip:x86/trace] x86, trace: Add page fault tracepoints
Thread-Index: AQHO3Ne5JH//O9og7ESA5GR79xhCwZogCoiAgAB+MAD//6xZoA==
Date: Mon, 11 Nov 2013 16:02:44 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D47F9EC03A@USINDEM103.corp.hds.com>
References: <52716E67.6090705@hds.com>
 <tip-d34603b07c4255b2b00a546d34f297ccd50ae4c6@git.kernel.org>
 <20131111082955.GB12405@gmail.com> <5280FF5E.2090009@zytor.com>
In-Reply-To: <5280FF5E.2090009@zytor.com>
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
 definitions=2013-11-11_02:2013-11-09,2013-11-11,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1311110097
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Seiji - are you okay with this?  If so I'll just make a quick patch now.
>

I'm OK with it.

Seiji
