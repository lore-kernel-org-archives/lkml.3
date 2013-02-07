Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517Ab3BGNWw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 08:22:52 -0500
Received: from mga03.intel.com ([143.182.124.21]:22948 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261Ab3BGNWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 08:22:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,622,1355126400"; 
   d="scan'208";a="253787575"
From: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        spear-devel <spear-devel@list.st.com>
Subject: Re: [PATCH] dw_dmac: adjust slave_id accordingly to request line
 base
Thread-Topic: [PATCH] dw_dmac: adjust slave_id accordingly to request line
 base
Thread-Index: AQHOBTY35FBAmkPv1kuygLrmdJOiAg==
Date: Thu, 7 Feb 2013 13:22:46 +0000
Message-ID: <1360243354.32329.20.camel@smile>
References: <1359371060-9044-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <CAOh2x==psH4fYmr_MxwO8vjYb=sWk=V7Vs8fs_-6U00gmiko_w@mail.gmail.com>
	 <20130129052247.GH2239@intel.com>
	 <CAOh2x=nTJ1iz9aoR8VrkE5A+iaLMMbvFeebGPsO8KWRpDLw7=A@mail.gmail.com>
	 <1359531176.31148.46.camel@smile>
	 <CAOh2x==Ng1=iHOj-55mUTWCwpaJpRXjiQyfxz-a48ALDOW3aiA@mail.gmail.com>
	 <1359533274.31148.52.camel@smile>
In-Reply-To: <1359533274.31148.52.camel@smile>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.173]
Content-Type: text/plain; charset="utf-8"
Content-ID: <314A93787C31244EB4184BDE1D18D528@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r17DMra9029032

On Wed, 2013-01-30 at 10:07 +0200, Andy Shevchenko wrote: 
> On Wed, 2013-01-30 at 13:31 +0530, Viresh Kumar wrote: 
> > On Wed, Jan 30, 2013 at 1:02 PM, Andy Shevchenko
> > <andriy.shevchenko@linux.intel.com> wrote:
> > > We get a device from the ACPI CSRT table. During enumeration we don't
> > > know what kind of the device it is. From the enumeration point of view
> > > each device enumerated from CSRT is a platform device (see
> > > drivers/acpi/csrt.c for the details).
> > >
> > > That's why we have to pass this info somehow to the DMAC driver. And
> > > like Mika already mentioned we have no other generic way except
> > > IORESOURCE_DMA. If you have something better in mind, please share. We
> > > could adopt our code then.
> > 
> > You don't need this in DT case too? 
> 
> I think no. It seems the DT has a proper backlink from the slave device
> to the dmac ("dma-names" property if I understood it correctly).

Actually I meant "dmas" property in the brackets.

> > Or only for ACPI case?
> 
> ACPI 5 case only until now.
> We would like to initiate the proposal to the ACPI specification
> team/whoever to have this part designed better in next versions.
> 
> > I think "Yes" is the answer of both the questions. If so, then you
> > can keep it this way or add another variable in platform data.

So, are you fine with it? Could you please Ack it if there is neither
objections nor more comments.

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
