Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbaKCNJ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 08:09:56 -0500
Received: from mail-ig0-f170.google.com ([209.85.213.170]:38899 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbaKCNJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 08:09:55 -0500
Date: Mon, 3 Nov 2014 13:09:49 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Raymond Tan <raymond.tan@intel.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, Alvin Chen <alvin.chen@intel.com>
Subject: Re: [PATCH 1/1] mfd: intel_quark_i2c_gpio: Add Intel Quark X1000
 I2C-GPIO MFD Driver
Message-ID: <20141103130949.GG4538@x1>
References: <1415000344-23575-1-git-send-email-raymond.tan@intel.com>
 <1415000344-23575-2-git-send-email-raymond.tan@intel.com>
 <1415005892.2396.82.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1415005892.2396.82.camel@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Nov 2014, Andy Shevchenko wrote:

> On Mon, 2014-11-03 at 15:39 +0800, Raymond Tan wrote:
> > In Quark X1000, there's a single PCI device that provides both
> > an I2C controller and a GPIO controller. This MFD driver will
> > split the 2 devices for their respective drivers.
> > 
> > This patch is based on Josef Ahmad's initial work for Quark enabling.
> 
> Few comments below.
> 
> After addressing take my
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[...]

> > +static const struct i2c_mode_info platform_i2c_mode_info[] = {
> > +	{
> > +		.name = "Galileo",
> > +		.i2c_scl_freq = 100000,
> > +	},
> > +	{
> > +		.name = "GalileoGen2",
> > +		.i2c_scl_freq = 400000,
> > +	},
> 
> You can decrease indentation level if you want to by using
> 
> = {{
> }, {
> }};
> 
> Though I don't know if Lee likes it :-)

No, please don't do that.

[...]

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
