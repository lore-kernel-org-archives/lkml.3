Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab3J3X1t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 19:27:49 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:42697 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab3J3X1r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 19:27:47 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "Luck, Tony" <tony.luck@intel.com>, Madper Xie <cxie@redhat.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "ccross@android.com" <ccross@android.com>,
        "anton@enomsg.org" <anton@enomsg.org>
CC: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bbboson@gmail.com" <bbboson@gmail.com>
Subject: RE: [PATCH 0/2] make all stored entries accessible.
Thread-Topic: [PATCH 0/2] make all stored entries accessible.
Thread-Index: AQHO1VS/gENfXKMKsEu0OLLoqy46ppoOAbKA///bNIA=
Date: Wed, 30 Oct 2013 23:27:14 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D47F9D4476@USINDEM103.corp.hds.com>
References: <1383126294-28793-1-git-send-email-cxie@redhat.com>
 <3908561D78D1C84285E8C5FCA982C28F31D529D7@ORSMSX106.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31D529D7@ORSMSX106.amr.corp.intel.com>
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
 definitions=2013-10-30_07:2013-10-31,2013-10-30,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1310300213
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ah - I was expecting that the backend driver would have a unique "id" for
> each record stored ... but is seems that this isn't true for efivars.
> 

So, do you mean efivars should fix to use the "id" in a proper way?

I acked Madper's patch 2/2 earlier today, but when I look at your test result, I'm not sure if
it is reasonable for users to make multiple numbers visible to the file name.

> -r--r--r-- 1 root root 17499 Oct 30 13:41 dmesg-erst-5940651313304961029--2129078373-1383165669

Seiji
