Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbaGVODp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 10:03:45 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:54689 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbaGVODo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 10:03:44 -0400
Date: Tue, 22 Jul 2014 15:03:38 +0100
From: Lee Jones <lee.jones@linaro.org>
To: pramod gurav <pramod.gurav.etc@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/19] mfd: max8925-i2c: Fix 'blank line after
 declarations' warning
Message-ID: <20140722140338.GF16065@lee--X1>
References: <1406027485-15657-1-git-send-email-lee.jones@linaro.org>
 <1406027485-15657-3-git-send-email-lee.jones@linaro.org>
 <CAMf-jSn5zZ1FBt+atzB9frZZ6yu_OTTfmJF2e7CEgQDbdzytBg@mail.gmail.com>
 <20140722121556.GC16065@lee--X1>
 <CAMf-jSmyJ1r8eFe-kU2LwgYzNuqkNqNHvUVk088f4AUaULEugg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMf-jSmyJ1r8eFe-kU2LwgYzNuqkNqNHvUVk088f4AUaULEugg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jul 2014, pramod gurav wrote:

> On Tue, Jul 22, 2014 at 5:45 PM, Lee Jones <lee.jones@linaro.org> wrote:
> > On Tue, 22 Jul 2014, pramod gurav wrote:
> >> There are more such changes required in this file. If they could go
> >> with this, will be good.
> >
> > Checkpatch only found this one:
> Yes, there is only one missing blank warning in this source file. What
> I was pointing out to was the extra line you added before return
> statement. There are more such extra lines needed.
> I created a patch for that but I am not sure how I would insert that
> here in between this reply.

Well to be honest, I was just being cheeky with that change, as it's
not really an issue, just a preference of mine.  If you really feel
passionate about it I will accept your patch if you submit it based on
for-mfd-next in the MFD repo [1].

> >> WARNING: Missing a blank line after declarations
> >> #260: FILE: drivers/mfd/max8925-i2c.c:260:
> >> +     int ret;
> >> +     ret = i2c_add_driver(&max8925_driver);
> >>
> >> total: 0 errors, 1 warnings, 275 lines checked
> >
> > Can you point me to the others please?

[1] git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
