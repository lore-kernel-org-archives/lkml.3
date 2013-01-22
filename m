Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab3AVAmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 19:42:39 -0500
Received: from mga01.intel.com ([192.55.52.88]:51535 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687Ab3AVAmi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 19:42:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,510,1355126400"; 
   d="scan'208";a="276729284"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        Omar Ramirez Luna <omar.ramirez@copitl.com>
Subject: RE: [PATCH] mfd, TWL4030: TWL4030 need select REGMAP_I2C
Thread-Topic: [PATCH] mfd, TWL4030: TWL4030 need select REGMAP_I2C
Thread-Index: AQHN+Di7cinxLKLtkUKx6vdeiH1/EJhUggaA
Date: Tue, 22 Jan 2013 00:42:34 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A215629@SHSMSX101.ccr.corp.intel.com>
References: <1356358796.1688.3.camel@cliu38-desktop-build>
 <50E162F8.8030403@ti.com>
 <27240C0AC20F114CBF8149A2696CBE4A203154@SHSMSX101.ccr.corp.intel.com>
 <20130122003720.GE7409@sortiz-mobl>
In-Reply-To: <20130122003720.GE7409@sortiz-mobl>
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

Thanks Samuel and Linus' help.

> -----Original Message-----
> From: Samuel Ortiz [mailto:sameo@linux.intel.com]
> Sent: Tuesday, January 22, 2013 8:37 AM
> To: Liu, Chuansheng
> Cc: Peter Ujfalusi; gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> torvalds@linux-foundation.org; Omar Ramirez Luna
> Subject: Re: [PATCH] mfd, TWL4030: TWL4030 need select REGMAP_I2C
> 
> Hi Liu,
> 
> On Mon, Jan 14, 2013 at 02:18:04AM +0000, Liu, Chuansheng wrote:
> > Hi maintainers,
> >
> > Could you help to push this patch?
> > Every time syncing the latest code, always meet this build error.
> > Sorry to disturb.
> I was going to take this one when I saw Linus already applied it directly.
> Sorry for the latency.
> 
> Cheers,
> Samuel.
> 
> --
> Intel Open Source Technology Centre
> http://oss.intel.com/
