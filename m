Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbaESWff (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 18:35:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:35580 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbaESWfc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 18:35:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,870,1392192000"; 
   d="scan'208";a="541727907"
From: "Luck, Tony" <tony.luck@intel.com>
To: Xie XiuQi <xiexiuqi@huawei.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Steven Rostedt" <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Mauro Chehab <m.chehab@samsung.com>
Subject: RE: [PATCH] time: Provide full featured jiffies_to_nsecs() function
Thread-Topic: [PATCH] time: Provide full featured jiffies_to_nsecs() function
Thread-Index: AQHPcwGiIK4lOPm6x0SG99JQVqbgGJtIeXuQ
Date: Mon, 19 May 2014 22:35:31 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F3280EB34@ORSMSX114.amr.corp.intel.com>
References: <0286550@agluck-desk.sc.intel.com> <53795E3B.9000004@huawei.com>
In-Reply-To: <53795E3B.9000004@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Another problem, maybe we should use get_jiffies_64() instead of jiffies
> directly here OR we'll meet wraparound problems on 32bit system. But a
> same problem is that the jiffies_lock is not safe in NMI context...

To quote Winnie the Pooh - "Bother".

Can someone think of a clever way to get a sane 64 bit jiffie value on
32-bit systems (even when we get an NMI in the middle of updating the
64-bit jiffie)?

-Tony
