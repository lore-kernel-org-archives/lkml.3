Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab3LPMVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 07:21:35 -0500
Received: from mga02.intel.com ([134.134.136.20]:59210 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753797Ab3LPMVd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 07:21:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,494,1384329600"; 
   d="scan'208";a="425327086"
From: "Ren, Qiaowei" <qiaowei.ren@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
CC: "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] x86: add user_atomic_cmpxchg_inatomic at uaccess.h
Thread-Topic: [PATCH 1/2] x86: add user_atomic_cmpxchg_inatomic at uaccess.h
Thread-Index: AQHO+FiKo8EtukZqDk2x7yIAJB80AZpWwSMw
Date: Mon, 16 Dec 2013 12:21:27 +0000
Message-ID: <9E0BE1322F2F2246BD820DA9FC397ADE014B2C09@SHSMSX102.ccr.corp.intel.com>
References: <1387002303-6620-1-git-send-email-qiaowei.ren@intel.com>
In-Reply-To: <1387002303-6620-1-git-send-email-qiaowei.ren@intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Qiaowei Ren wrote: 
> This patch adds user_atomic_cmpxchg_inatomic() to use CMPXCHG instruction
> against a user space address.
> 
> This generalizes the already existing futex_atomic_cmpxchg_inatomic() so it
> can be used in other contexts.  This will be used in the upcoming support for
> Intel MPX (Memory Protection Extensions.)
> 
Peter, do you have any other comments for this version?

Thanks,
Qiaowei
