Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293AbbATNlw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 08:41:52 -0500
Received: from mga09.intel.com ([134.134.136.24]:19292 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726AbbATNlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 08:41:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,434,1418112000"; 
   d="scan'208";a="639843668"
From: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
To: "lee.jones@linaro.org" <lee.jones@linaro.org>
CC: "mturquette@linaro.org" <mturquette@linaro.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chen, Alvin" <alvin.chen@intel.com>,
        "Tan, Raymond" <raymond.tan@intel.com>
Subject: Re: [PATCH v3 1/1] mfd: intel_quark_i2c_gpio: Add Intel Quark X1000
 I2C-GPIO MFD Driver
Thread-Topic: [PATCH v3 1/1] mfd: intel_quark_i2c_gpio: Add Intel Quark
 X1000 I2C-GPIO MFD Driver
Thread-Index: AQHQNK9KkoFpvfa40kexjfgJp3n0NpzJBFMA
Date: Tue, 20 Jan 2015 13:41:48 +0000
Message-ID: <1421761312.31903.64.camel@intel.com>
References: <1418290710-5871-1-git-send-email-raymond.tan@intel.com>
	 <1418290710-5871-2-git-send-email-raymond.tan@intel.com>
	 <20150120124745.GE13701@x1>
In-Reply-To: <20150120124745.GE13701@x1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.90]
Content-Type: text/plain; charset="utf-8"
Content-ID: <CB61EE95406A61458DC970559A46B174@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0KDfvvV012357

On Tue, 2015-01-20 at 12:47 +0000, Lee Jones wrote:
> On Thu, 11 Dec 2014, Raymond Tan wrote:

[]

> > +static const struct i2c_mode_info platform_i2c_mode_info[] = {
> > +	{
> > +		.name = "Galileo",
> > +		.i2c_scl_freq = 100000,
> > +	},
> > +	{
> > +		.name = "GalileoGen2",
> > +		.i2c_scl_freq = 400000,
> > +	},
> > +};
> 
> We normally do not capitalise device names.

This comes from DMI, so, can't be altered I suppose.

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
