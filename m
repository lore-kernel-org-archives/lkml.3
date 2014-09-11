Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709AbaIKHyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 03:54:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:61570 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996AbaIKHyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 03:54:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,504,1406617200"; 
   d="scan'208";a="571618058"
From: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
To: "Koul, Vinod" <vinod.koul@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>,
        "hskinnemoen@gmail.com" <hskinnemoen@gmail.com>,
        "tiwai@suse.de" <tiwai@suse.de>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "alan@linux.jf.intel.com" <alan@linux.jf.intel.com>,
        "andriy.shevchenko@linux.jf.intel.com" 
	<andriy.shevchenko@linux.jf.intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "hein_tibosch@yahoo.es" <hein_tibosch@yahoo.es>,
        "mika.westerberg@linux.jf.intel.com" 
	<mika.westerberg@linux.jf.intel.com>,
        "egtvedt@samfundet.no" <egtvedt@samfundet.no>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Subject: Re: [PATCH v1 00/12] dmaengine: dw: remove slave_id, add PCI support
Thread-Topic: [PATCH v1 00/12] dmaengine: dw: remove slave_id, add PCI
 support
Thread-Index: AQHPzZWD0hKKUB+ENkW6JR57cYTWjw==
Date: Thu, 11 Sep 2014 07:53:46 +0000
Message-ID: <1410422026.7023.13.camel@intel.com>
References: <1408469363-15901-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <20140911064212.GI3131@intel.com>
In-Reply-To: <20140911064212.GI3131@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.168]
Content-Type: text/plain; charset="utf-8"
Content-ID: <3B89242C628F2046A9324B3C1A47E598@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8B7sI1T021736

On Thu, 2014-09-11 at 12:12 +0530, Vinod Koul wrote:
> On Tue, Aug 19, 2014 at 08:29:11PM +0300, Andy Shevchenko wrote:
> > The patchset is targeting two things:
> >  - removal of slave_id which is deprecated (suggested by Arnd Bergmann)
> >  - support BayTrail and Braswell SoCs in PCI case
> > 
> > They are tight with each other, thus comes in one series.
> > 
> > The patch set was BAT tested on Braswell and BayTrail machines.
> > 
> > We would like to push this through slave-dma tree, so, Mark, Greg,
> > Hans-Christian, and Haavard, please, Ack them if you have no objections.
> > 
> > Vinod, we would like them to be pushed during this cycle since we have more
> > coming. And it would be nice to have Braswell support in v3.18-rc1.
> 
> Applied all 

Thanks!

> except the three SPI patches. One of them Mark has applied, rest
> dont apply for me, so pls resend with acks.

Done!

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
