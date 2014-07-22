Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552AbaGVMQE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 08:16:04 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:40546 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064AbaGVMQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 08:16:02 -0400
Date: Tue, 22 Jul 2014 13:15:56 +0100
From: Lee Jones <lee.jones@linaro.org>
To: pramod gurav <pramod.gurav.etc@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 02/19] mfd: max8925-i2c: Fix 'blank line after
 declarations' warning
Message-ID: <20140722121556.GC16065@lee--X1>
References: <1406027485-15657-1-git-send-email-lee.jones@linaro.org>
 <1406027485-15657-3-git-send-email-lee.jones@linaro.org>
 <CAMf-jSn5zZ1FBt+atzB9frZZ6yu_OTTfmJF2e7CEgQDbdzytBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMf-jSn5zZ1FBt+atzB9frZZ6yu_OTTfmJF2e7CEgQDbdzytBg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jul 2014, pramod gurav wrote:

> On Tue, Jul 22, 2014 at 4:41 PM, Lee Jones <lee.jones@linaro.org> wrote:
> > This is part of an effort to clean-up the MFD subsystem.
> >
> > WARNING: Missing a blank line after declarations
> > +       int ret;
> > +       ret = i2c_add_driver(&max8925_driver);
> >
> > total: 0 errors, 1 warnings, 275 lines checked
> >
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/mfd/max8925-i2c.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/drivers/mfd/max8925-i2c.c b/drivers/mfd/max8925-i2c.c
> > index a83eed5..ecbe78e 100644
> > --- a/drivers/mfd/max8925-i2c.c
> > +++ b/drivers/mfd/max8925-i2c.c
> > @@ -257,9 +257,11 @@ static struct i2c_driver max8925_driver = {
> >  static int __init max8925_i2c_init(void)
> >  {
> >         int ret;
> > +
> >         ret = i2c_add_driver(&max8925_driver);
> >         if (ret != 0)
> >                 pr_err("Failed to register MAX8925 I2C driver: %d\n", ret);
> > +
> There are more such changes required in this file. If they could go
> with this, will be good.

Checkpatch only found this one:

> WARNING: Missing a blank line after declarations
> #260: FILE: drivers/mfd/max8925-i2c.c:260:
> +	int ret;
> +	ret = i2c_add_driver(&max8925_driver);
> 
> total: 0 errors, 1 warnings, 275 lines checked

Can you point me to the others please?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
