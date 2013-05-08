Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841Ab3EHSOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 14:14:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:17145 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757465Ab3EHSOP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 14:14:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,636,1363158000"; 
   d="scan'208";a="334526776"
From: "Luck, Tony" <tony.luck@intel.com>
To: Wei Yongjun <weiyj.lk@gmail.com>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        "ccross@android.com" <ccross@android.com>,
        "keescook@chromium.org" <keescook@chromium.org>
CC: "yongjun_wei@trendmicro.com.cn" <yongjun_wei@trendmicro.com.cn>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] pstore/ram: fix error return code in ramoops_probe()
Thread-Topic: [PATCH] pstore/ram: fix error return code in ramoops_probe()
Thread-Index: AQHOSxeQZv0LHGlbwkuaXGtoAKtqQpj7mTYw
Date: Wed, 8 May 2013 18:14:11 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F2DA47957@ORSMSX101.amr.corp.intel.com>
References: <CAPgLHd9w_PpotgpN+KZKs79W4xZrLsBNxRsh+DjspeMxc+vxpA@mail.gmail.com>
In-Reply-To: <CAPgLHd9w_PpotgpN+KZKs79W4xZrLsBNxRsh+DjspeMxc+vxpA@mail.gmail.com>
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

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.

Applied - will be in a "please pull" to Linus soon.

Thanks

-Tony

