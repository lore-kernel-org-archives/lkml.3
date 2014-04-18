Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751317AbaDRGhA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 02:37:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:38499 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959AbaDRGg5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 02:36:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,883,1389772800"; 
   d="scan'208";a="495183490"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Zhao, Yakui" <yakui.zhao@intel.com>
Subject: RE: [PATCH] ACPICA: Tables: Skip NULL entries in RSDT and XSDT.
Thread-Topic: [PATCH] ACPICA: Tables: Skip NULL entries in RSDT and XSDT.
Thread-Index: AQHPWrAcRbIEWi18XUqckj4NN5SyAZsWrGRA//+HzYCAALcRAA==
Date: Fri, 18 Apr 2014 06:36:48 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E8802554D4E@SHSMSX101.ccr.corp.intel.com>
References: <261e2207fab4a185b44fb27dbf9bc68588aea713.1397785844.git.lv.zheng@intel.com>
 <20140418024426.GA10084@kroah.com>
 <1AE640813FDE7649BE1B193DEA596E8802554BEC@SHSMSX101.ccr.corp.intel.com>
 <20140418033945.GA20137@kroah.com>
In-Reply-To: <20140418033945.GA20137@kroah.com>
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

Hi,

> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Friday, April 18, 2014 11:40 AM
> 
> On Fri, Apr 18, 2014 at 03:00:21AM +0000, Zheng, Lv wrote:
> > Hi, Greg
> >
> > > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > > Sent: Friday, April 18, 2014 10:44 AM
> > >
> > > On Fri, Apr 18, 2014 at 09:53:19AM +0800, Lv Zheng wrote:
> > > > Note that this patch is only used for stable kernels, upstream kernels
> > > > will have this problem fixed in ACPICA 201303-04 release.  So upstream
> > > > kernels shouldn't merge this commit.
> > >
> > > What kernel commit fixed this issue in "upstream"?
> >
> > There is no kernel commit now has fixed this issue in "upstream".
> > The fix commit need to go into ACPICA first, so I believe it will
> > appear in 3.15-rc2 (ACPICA 201403xx release) or 3.15-rc3 (ACPICA
> > 201404xx release).
> 
> Then I can't take this patch at all in any stable tree.  Please read
> Documentation/stable_kernel_rules.txt for why and how to properly do
> this.
> 
> Just mark the commit that fixes the issue in Linus's tree for stable,
> and it will happen automatically.
> 

OK.

> > The back port of the fix commit will have many dependencies as we have
> > a big change in ACPICA table manager in ACPICA 201403xx release.
> 
> Why not just submit this fix first to Linus, for his tree now, and then
> do the larger changes later?
> 

OK.  It seems possible now.

> > However this back port is very light and has been confirmed by the reporters.
> >
> > The bug seems to be urgent, it has broken many platforms shipped with
> > AMI BIOSes versioning from F2 to F4.  Someone may monitor here to find
> > a valid fix.
> 
> Not any stable maintainers, we can't take patches that aren't in Linus's
> tree, sorry.
> 

OK.
I was just a little worried about as I'm the culprit.
Sorry for the noise.

Thanks and best regards
-Lv

> greg k-h
