Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbaAFLu3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 06:50:29 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:46755 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976AbaAFLu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 06:50:27 -0500
Date: Mon, 6 Jan 2014 11:50:21 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 4/7] mfd: ssbi: Add regmap read/write helpers
Message-ID: <20140106115021.GC30156@lee--X1>
References: <1387831563-13535-1-git-send-email-sboyd@codeaurora.org>
 <1387831563-13535-5-git-send-email-sboyd@codeaurora.org>
 <20131224125443.GC30815@sirena.org.uk>
 <20131226194133.GJ31766@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131226194133.GJ31766@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Dec 2013, Stephen Boyd wrote:

> On 12/24, Mark Brown wrote:
> > On Mon, Dec 23, 2013 at 12:46:00PM -0800, Stephen Boyd wrote:
> > 
> > > +int ssbi_reg_read(void *context, unsigned int reg, unsigned int *val)
> > > +{
> > > +	*val = 0;
> > > +	return ssbi_read(context, reg, (u8 *)val, 1);
> > > +}
> > > +EXPORT_SYMBOL_GPL(ssbi_reg_read);
> > > +
> > > +int ssbi_reg_write(void *context, unsigned int reg, unsigned int val)
> > > +{
> > > +	return ssbi_write(context, reg, (u8 *)&val, 1);
> > > +}
> > > +EXPORT_SYMBOL_GPL(ssbi_reg_write);
> > 
> > Not a big deal but could these just be inlined in the headers?
> 
> Sure, I can do that if I need to resend? The only benefit I see
> is two less symbols exported.

Yes please. After this review.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
