Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab3IQIGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 04:06:39 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:50466 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab3IQIGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 04:06:35 -0400
Date: Tue, 17 Sep 2013 09:06:29 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Wolfram Sang <wsa@the-dreams.de>, Linus Walleij <linus.walleij@linaro.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wang Shilong <wangshilong1991@gmail.com>
Subject: Re: [PATCH 1/4 v2] mfd: add STw481x driver
Message-ID: <20130917080629.GT16984@lee--X1>
References: <1379094851-26385-1-git-send-email-linus.walleij@linaro.org>
 <20130916091956.GF3999@lee--X1>
 <20130916104009.GA29403@sirena.org.uk>
 <CACRpkdatiELF3WK9qE_Mgcq3iCgv5w3X22xp1=232JJq9sWggQ@mail.gmail.com>
 <20130916135118.GD29403@sirena.org.uk>
 <20130916152104.GA3909@katana>
 <20130916153414.GN16984@lee--X1>
 <20130916160001.GC3909@katana>
 <20130916160537.GO16984@lee--X1>
 <20130916162428.GE29403@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130916162428.GE29403@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Sep 2013, Mark Brown wrote:

> On Mon, Sep 16, 2013 at 05:05:37PM +0100, Lee Jones wrote:
> > > > So in the mean time are you happy with this "dummy" approach?
> 
> > > No. "dummy" is reserved for a dummy device in case an i2c slave needs
> > > more than one address. The proper solution would be if
> > > i2c_sysfs_new_device() could recognize the of_device_ids.
> 
> > Okay, thanks for clarifying.
> 
> Or for now to use something like stw481x (even if it's never expected to
> actually make a difference).

If Linus wants to resubmit, I'm happy with that.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
