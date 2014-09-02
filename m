Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbaIBARv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 20:17:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:52628 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952AbaIBARu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 20:17:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,446,1406617200"; 
   d="scan'208";a="593056495"
From: "Chang, Rebecca Swee Fun" <rebecca.swee.fun.chang@intel.com>
To: "'Andy Shevchenko'" <andriy.shevchenko@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: RE: [PATCH v1 2/5] mfd: lpc_sch: better code manageability with
 chipset info struct
Thread-Topic: [PATCH v1 2/5] mfd: lpc_sch: better code manageability with
 chipset info struct
Thread-Index: AQHPxcV0RKnyyOV9Q0yBZcjqFyqFVZvrjFaAgAFuZpA=
Date: Tue, 2 Sep 2014 00:17:17 +0000
Message-ID: <50B33AC5ED75F74F991980326F1C438D0FBD15FE@PGSMSX108.gar.corp.intel.com>
References: <1408705096-31286-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1408705096-31286-3-git-send-email-andriy.shevchenko@linux.intel.com>
	 <20140901091607.GH7374@lee--X1> <1409567105.30155.49.camel@linux.intel.com>
In-Reply-To: <1409567105.30155.49.camel@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.205]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s820HtwY008953



> -----Original Message-----
> From: Andy Shevchenko [mailto:andriy.shevchenko@linux.intel.com]
> Sent: 01 September, 2014 6:25 PM
> To: Lee Jones
> Cc: Bjorn Helgaas; linux-kernel@vger.kernel.org; Samuel Ortiz; Chang, Rebecca
> Swee Fun
> Subject: Re: [PATCH v1 2/5] mfd: lpc_sch: better code manageability with
> chipset info struct
> 
> On Mon, 2014-09-01 at 10:16 +0100, Lee Jones wrote:
> > On Fri, 22 Aug 2014, Andy Shevchenko wrote:
> >
> > > Introduce additional struct to hold chipset info. This chipset info
> > > will be used to store features that are supported by specific
> > > processor or chipset. LPC_SCH supports SMBUS, GPIO and WDT features.
> > > As this code base might expand further to support more processors,
> > > this implementation will help to keep code base clean and manageable.
> > >
> > > Signed-off-by: Chang Rebecca Swee Fun
> > > <rebecca.swee.fun.chang@intel.com>
> > > Tested-by: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
> > > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> []
> 
> 
> > The first patch would look a great deal cleaner if it had these
> > changes in too.  Unless you have a really good reason not to, please
> > consider squashing them.
> 
> The only reason behind is that this patch (in other form) was written by
> Rebecca in the first place. I recommended to clean up before, and actually did
> that clean up and amended Rebecca's patch.
> 
> So, if Rebecca has now objections I could squash it.

I have no objections. Thanks.

> 
> 
> --
> Andy Shevchenko <andriy.shevchenko@intel.com> Intel Finland Oy

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
