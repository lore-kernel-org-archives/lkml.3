Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbaBUUTj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 15:19:39 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:21619 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752417AbaBUUTh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 15:19:37 -0500
From: Bing Zhao <bzhao@marvell.com>
To: Fengguang Wu <fengguang.wu@intel.com>, Yogesh Powar <yogeshp@marvell.com>
CC: Nishant Sarmukadam <nishants@marvell.com>,
        Frank Huang <frankh@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 21 Feb 2014 12:19:27 -0800
Subject: RE: [mwifiex/USB8897] Error: Driver 'usb8xxx' is already
 registered, aborting...
Thread-Topic: [mwifiex/USB8897] Error: Driver 'usb8xxx' is already
 registered, aborting...
Thread-Index: Ac8u4lQTZ0EEFVIFRGWOlzmx4M7PjgAX51Vg
Message-ID: <477F20668A386D41ADCC57781B1F70430F53B2A485@SC-VEXCH1.marvell.com>
References: <20140221085235.GA2055@localhost>
In-Reply-To: <20140221085235.GA2055@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-02-21_06:2014-02-21,2014-02-21,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1402210134
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fengguang,

> Greetings,
> 
> I got the below dmesg and the first bad commit is
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> commit 68458dede7e0055198318dcb0318df3b4f419507
> CommitDate: Mon Jan 13 14:46:59 2014 -0500
> 
>     mwifiex: add USB8897 support
> 
> [    6.211307] Error: Driver 'usb8xxx' is already registered, aborting...
> [    6.211307] Error: Driver 'usb8xxx' is already registered, aborting...
> [    6.217261] mwifiex_usb: Driver register failed!
> [    6.217261] mwifiex_usb: Driver register failed!

Thanks for reporting this bug.
I will send the patch to fix it shortly.

Regards,
Bing

