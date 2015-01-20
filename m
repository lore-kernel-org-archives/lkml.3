Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776AbbATPzF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 10:55:05 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:46282 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbbATPzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 10:55:02 -0500
Date: Tue, 20 Jan 2015 15:54:53 +0000
From: Lee Jones <lee.jones@linaro.org>
To: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
Cc: "mturquette@linaro.org" <mturquette@linaro.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chen, Alvin" <alvin.chen@intel.com>,
        "Tan, Raymond" <raymond.tan@intel.com>
Subject: Re: [PATCH v3 1/1] mfd: intel_quark_i2c_gpio: Add Intel Quark X1000
 I2C-GPIO MFD Driver
Message-ID: <20150120155453.GJ13701@x1>
References: <1418290710-5871-1-git-send-email-raymond.tan@intel.com>
 <1418290710-5871-2-git-send-email-raymond.tan@intel.com>
 <20150120124745.GE13701@x1>
 <1421761312.31903.64.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1421761312.31903.64.camel@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jan 2015, Shevchenko, Andriy wrote:

> On Tue, 2015-01-20 at 12:47 +0000, Lee Jones wrote:
> > On Thu, 11 Dec 2014, Raymond Tan wrote:
> 
> []
> 
> > > +static const struct i2c_mode_info platform_i2c_mode_info[] = {
> > > +	{
> > > +		.name = "Galileo",
> > > +		.i2c_scl_freq = 100000,
> > > +	},
> > > +	{
> > > +		.name = "GalileoGen2",
> > > +		.i2c_scl_freq = 400000,
> > > +	},
> > > +};
> > 
> > We normally do not capitalise device names.
> 
> This comes from DMI, so, can't be altered I suppose.

I'm not sure what that means, but sounds reasonable.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
