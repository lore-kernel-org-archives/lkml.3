Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760425Ab3JPJNp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 05:13:45 -0400
Received: from mga03.intel.com ([143.182.124.21]:60228 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760109Ab3JPJNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 05:13:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,506,1378882800"; 
   d="scan'208";a="411778762"
From: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
To: "Koul, Vinod" <vinod.koul@intel.com>
CC: "Williams, Dan J" <dan.j.williams@intel.com>,
        Youquan Song <youquan.song@linux.jf.intel.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Song, Youquan" <youquan.song@intel.com>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] dma: Add interface to calculate data transferred
Thread-Topic: [PATCH 1/2] dma: Add interface to calculate data transferred
Thread-Index: AQHOxmj7TKNMun2fTEyCvrAxr1aQIZnvb2yAgANEMICAA1hkAP//1FAAgADmHoCAAEd+kf//9FIA
Date: Wed, 16 Oct 2013 09:13:20 +0000
Message-ID: <1381914782.29062.137.camel@smile>
References: <1381527738-9339-1-git-send-email-youquan.song@intel.com>
	 <1381527738-9339-2-git-send-email-youquan.song@intel.com>
	 <20131011133343.GB32689@kroah.com> <20131013152633.GM2954@intel.com>
	 <20131015183142.GA12494@linux-youquan.bj.intel.com>
	 <CAPcyv4jJSgM7EmDMW-rcjVCnC6-95+qeU9yf+yxD-wMCcQ8amg@mail.gmail.com>
	 <20131016053857.GV2954@intel.com> <1381912571.29062.135.camel@smile>
	 <20131016075702.GW2954@intel.com>
In-Reply-To: <20131016075702.GW2954@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.173]
Content-Type: text/plain; charset="utf-8"
Content-ID: <F27905C4A0B1994CB4013484186E5C16@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r9G9Doqn031460

On Wed, 2013-10-16 at 13:27 +0530, Vinod Koul wrote:
> On Wed, Oct 16, 2013 at 02:06:30PM +0530, Shevchenko, Andriy wrote:
> > On Wed, 2013-10-16 at 11:08 +0530, Vinod Koul wrote:

[]

> > > Well am going to take it a bit further and ask you why do we need the
> > > /sys/class/dma? I have never used it for slave work.
> > 
> > How user (who, f.e., would like to run dmatest) will know names of the
> > channels provided?
> Ok dmatest requires this, I overlooked that part
> 
> > How could we see what channels of certain dma controller are requested /
> > busy from userspace?
> But do end user care or need to know about this?

The idea is to have some test cases. So, end user probably doesn't
really need this.

-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy
---------------------------------------------------------------------
Intel Finland Oy
Registered Address: PL 281, 00181 Helsinki 
Business Identity Code: 0357606 - 4 
Domiciled in Helsinki 

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
