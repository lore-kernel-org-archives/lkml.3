Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbbATRbm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 12:31:42 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:50005 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbbATRbl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 12:31:41 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Lee Jones <lee.jones@linaro.org>, "Raymond Tan" <raymond.tan@intel.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <20150120124745.GE13701@x1>
Cc: "Samuel Ortiz" <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        "Alvin Chen" <alvin.chen@intel.com>,
        "Andriy Shevchenko" <andriy.shevchenko@intel.com>
References: <1418290710-5871-1-git-send-email-raymond.tan@intel.com>
 <1418290710-5871-2-git-send-email-raymond.tan@intel.com>
 <20150120124745.GE13701@x1>
Message-ID: <20150120173130.22722.14385@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v3 1/1] mfd: intel_quark_i2c_gpio: Add Intel Quark X1000 I2C-GPIO
 MFD Driver
Date: Tue, 20 Jan 2015 09:31:30 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Lee Jones (2015-01-20 04:47:46)
> On Thu, 11 Dec 2014, Raymond Tan wrote:
> > +             CLK_IS_ROOT, INTEL_QUARK_I2C_CLK_HZ);
> > +
> > +     quark_mfd->i2c_clk_lookup = i2c_clk_lookup;
> > +     quark_mfd->i2c_clk = i2c_clk;
> > +
> > +     retval = clk_register_clkdevs(i2c_clk, i2c_clk_lookup,
> > +                                   INTEL_QUARK_I2C_NCLK);
> > +     if (retval)
> > +             dev_err(&pdev->dev, "Fixed clk register failed: %d\n", retval);
> > +
> > +     return retval;
> > +}
> 
> I wouldn't mind a clk Ack on this.  Did you Cc Mike already?

Yes he did and I just supplied it in a parallel thread.

Regards,
Mike
