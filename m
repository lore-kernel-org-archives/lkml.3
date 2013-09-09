Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab3IIXfl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 19:35:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:30158 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755528Ab3IIXfk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 19:35:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,874,1371106800"; 
   d="scan'208";a="400896194"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Robin Holt <robinmholt@linux.com>
CC: "mingo@kernel.org" <mingo@kernel.org>, "holt@sgi.com" <holt@sgi.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "rmk+kernel@arm.linux.org.uk" <rmk+kernel@arm.linux.org.uk>,
        "rja@sgi.com" <rja@sgi.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Li, Fei" <fei.li@intel.com>
Subject: RE: [PATCH] reboot: re-enable the function of variable
 reboot_default
Thread-Topic: [PATCH] reboot: re-enable the function of variable
 reboot_default
Thread-Index: AQHOrW5T7JTOOWAWh0S2jCkzctlzRZm+DmUQ
Date: Mon, 9 Sep 2013 23:35:24 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A01B1BB0E@SHSMSX101.ccr.corp.intel.com>
References: <1378727380.26153.8.camel@cliu38-desktop-build>
 <20130909150616.GB28780@julie.rmholt.homeip.net>
In-Reply-To: <20130909150616.GB28780@julie.rmholt.homeip.net>
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



> -----Original Message-----
> From: Robin Holt [mailto:robinmholt@linux.com]
> Sent: Monday, September 09, 2013 11:07 PM
> To: Liu, Chuansheng
> Cc: mingo@kernel.org; holt@sgi.com; hpa@zytor.com;
> rmk+kernel@arm.linux.org.uk; rja@sgi.com; akpm@linux-foundation.org;
> linux-kernel@vger.kernel.org; Li, Fei
> Subject: Re: [PATCH] reboot: re-enable the function of variable reboot_default
> 
> On Mon, Sep 09, 2013 at 07:49:40PM +0800, Chuansheng Liu wrote:
> >
> > commit b3a5d02ee070c(reboot: move arch/x86 reboot= handling to generic
> kernel)
> 
> The commit id was really 1b3a5d02ee070c
> 
> > did some cleanup for reboot= command line, but it made the reboot_default
> > to be invalidated.
> >
> > The default value of variable reboot_default should be 1, and if command line
> > reboot= is not set, system will use the default reboot mode.
> >
> > Signed-off-by: Li Fei <fei.li@intel.com>
> > Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> 
> Acked-by: Robin Holt <robinmholt@linux.com>
> 
> Thank you for fixing my bug.
> 
> Note: My email address used to be holt@sgi.com
Thanks Robin to ack and notify, I also was wondering why the email is undelivered to your old EMAIL:)
