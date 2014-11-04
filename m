Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbaKDJLW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 04:11:22 -0500
Received: from mga03.intel.com ([134.134.136.65]:36652 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbaKDJLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 04:11:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,312,1413270000"; 
   d="scan'208";a="601846634"
From: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
To: "pure.logic@nexus-software.ie" <pure.logic@nexus-software.ie>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chen, Alvin" <alvin.chen@intel.com>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "Tan, Raymond" <raymond.tan@intel.com>
Subject: Re: [PATCH 1/1] mfd: intel_quark_i2c_gpio: Add Intel Quark X1000
 I2C-GPIO MFD Driver
Thread-Topic: [PATCH 1/1] mfd: intel_quark_i2c_gpio: Add Intel Quark X1000
 I2C-GPIO MFD Driver
Thread-Index: AQHP9zm97ciuT6Bv0UyJigPUJiZBvpxOpryAgAGJQ4A=
Date: Tue, 4 Nov 2014 09:10:48 +0000
Message-ID: <1415092249.472.5.camel@intel.com>
References: <1415000344-23575-1-git-send-email-raymond.tan@intel.com>
	 <1415000344-23575-2-git-send-email-raymond.tan@intel.com>
	 <54574E35.1030402@nexus-software.ie>
In-Reply-To: <54574E35.1030402@nexus-software.ie>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.173]
Content-Type: text/plain; charset="utf-8"
Content-ID: <F3F9EDDF1D00984284C33C83EA70C5C7@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sA49BVSP014843

On Mon, 2014-11-03 at 09:43 +0000, Bryan O'Donoghue wrote:
> On 03/11/14 07:39, Raymond Tan wrote:
> > In Quark X1000, there's a single PCI device that provides both
> > an I2C controller and a GPIO controller. This MFD driver will
> > split the 2 devices for their respective drivers.
> >
> > This patch is based on Josef Ahmad's initial work for Quark enabling.
> 
> Hi Raymond.
> 
> I see support for interrupts on GPIO input has been dropped. In fact it 
> doesn't appear you have any IRQ support here at all.
> 
> Could you detail the reasons why ?

In general the MFD drivers are just dispatchers which split an original
compound device by its slices.

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
