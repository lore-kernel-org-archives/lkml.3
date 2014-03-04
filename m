Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438AbaCDHsD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 02:48:03 -0500
Received: from mga11.intel.com ([192.55.52.93]:27142 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968AbaCDHsA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 02:48:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,583,1389772800"; 
   d="scan'208";a="485633131"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: "balbi@ti.com" <balbi@ti.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "mina86@mina86.com" <mina86@mina86.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Cohen, David A" <david.a.cohen@intel.com>,
        "Zhuang, Jin Can" <jin.can.zhuang@intel.com>,
        "Wang, Yu Y" <yu.y.wang@intel.com>
Subject: RE: [PATCH] usb: gadget: return the right length in ffs_epfile_io()
Thread-Topic: [PATCH] usb: gadget: return the right length in ffs_epfile_io()
Thread-Index: AQHPNv4mVrVke8DJV02JJGdbJDJZXprQjaZQ
Date: Tue, 4 Mar 2014 07:47:58 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A01C3D5AF@SHSMSX101.ccr.corp.intel.com>
References: <n> <1393483771-24623-1-git-send-email-chuansheng.liu@intel.com>
 <20140303163013.GC2759@saruman.home>
In-Reply-To: <20140303163013.GC2759@saruman.home>
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

Hello Balbi,

> -----Original Message-----
> From: Felipe Balbi [mailto:balbi@ti.com]
> Sent: Tuesday, March 04, 2014 12:30 AM
> To: Liu, Chuansheng
> Cc: balbi@ti.com; gregkh@linuxfoundation.org; mina86@mina86.com;
> linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org; Cohen, David A;
> Zhuang, Jin Can; Wang, Yu Y
> Subject: Re: [PATCH] usb: gadget: return the right length in ffs_epfile_io()
> 
> Hi,
> 
> On Thu, Feb 27, 2014 at 02:49:31PM +0800, Chuansheng Liu wrote:
> > When the request length is aligned to maxpacketsize, sometimes
> > the return length ret > the user space requested len.
> >
> > At that time, we will use min_t(size_t, ret, len) to limit the
> > size in case of user data buffer overflow.
> >
> > But we need return the min_t(size_t, ret, len) to tell the user
> > space rightly also.
> >
> > Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>

> please rebase on my "testing/next" branch

Based on your branch "testing/next", I have sent patch v2 with some ack
and reviewing, thanks.

[PATCH v2] usb: gadget: return the right length in ffs_epfile_io()


Best Regards
Chuansheng

