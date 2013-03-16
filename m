Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201Ab3CPBWg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 21:22:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:16784 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932096Ab3CPBWe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 21:22:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,855,1355126400"; 
   d="scan'208";a="280268068"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "Li, Fei" <fei.li@intel.com>, "rjw@sisk.pl" <rjw@sisk.pl>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ldewangan@nvidia.com" <ldewangan@nvidia.com>
Subject: RE: [PATCH] pm: print the name of failed suspend function for
 platform device
Thread-Topic: [PATCH] pm: print the name of failed suspend function for
 platform device
Thread-Index: AQHOIbIsii1CID+liUi8UiNF1Nk0i5inhVQA
Date: Sat, 16 Mar 2013 01:22:31 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A25BE7A@SHSMSX101.ccr.corp.intel.com>
References: <1360041183.15311.2.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
 <27240C0AC20F114CBF8149A2696CBE4A254DD3@SHSMSX101.ccr.corp.intel.com>
 <20130315192024.GB11988@kroah.com>
In-Reply-To: <20130315192024.GB11988@kroah.com>
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

Hello Greg,

Double checked, there is no your response before.
Can you consider it again? Thanks.

Since we have printed the failure info, why not enhance it a bit:)

Example without this patch:
pm_op(): platform_pm_suspend+0x0/0x50 returns -11
PM: Device power.0 failed to suspend: error -11

And with this patch:
platform_pm_suspend(): power_suspend+0x0/0x30 returns -11
pm_op(): platform_pm_suspend+0x0/0x80 returns -11
PM: Device power.0 failed to suspend: error -11


> -----Original Message-----
> From: gregkh@linuxfoundation.org [mailto:gregkh@linuxfoundation.org]
> Sent: Saturday, March 16, 2013 3:20 AM
> To: Liu, Chuansheng
> Cc: Li, Fei; rjw@sisk.pl; akpm@linux-foundation.org;
> linux-kernel@vger.kernel.org; ldewangan@nvidia.com
> Subject: Re: [PATCH] pm: print the name of failed suspend function for platform
> device
> 
> On Mon, Mar 11, 2013 at 01:41:28AM +0000, Liu, Chuansheng wrote:
> > Hi Greg,
> >
> > I just noticed some other cases need the more log also.
> > https://lkml.org/lkml/2013/3/8/71
> >
> > Could you consider the below patch, thanks?
> 
> Didn't I already consider it and respond?

