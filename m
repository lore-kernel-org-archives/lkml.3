Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbaJGKCh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 06:02:37 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:56213 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbaJGKCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 06:02:34 -0400
Date: Tue, 7 Oct 2014 11:02:28 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Subject: Re: [PATCH 2/2] mfd: remove use of gpiochip_remove() retval
Message-ID: <20141007100228.GZ25331@lee--X1>
References: <1412086542-1662-1-git-send-email-pramod.gurav@smartplayin.com>
 <1412086542-1662-2-git-send-email-pramod.gurav@smartplayin.com>
 <CACRpkdZVyxN+W_8s3Hvij0wu=bE-tyAFhJPVKumRvDkpUDuncA@mail.gmail.com>
 <20141007091417.GM25331@lee--X1>
 <CACRpkdayTNQNUDw_eZ9brDBAbd-iSLumJrQrrVnABt=C92kUOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdayTNQNUDw_eZ9brDBAbd-iSLumJrQrrVnABt=C92kUOA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Oct 2014, Linus Walleij wrote:

> On Tue, Oct 7, 2014 at 11:14 AM, Lee Jones <lee.jones@linaro.org> wrote:
> > On Wed, 01 Oct 2014, Linus Walleij wrote:
> >
> >> On Tue, Sep 30, 2014 at 4:15 PM, Pramod Gurav
> >> <pramod.gurav@smartplayin.com> wrote:
> >>
> >> > Get rid of using return value from gpiochip_remove() as it returns
> >> > void.
> >> >
> >> > Cc: Linus Walleij <linus.walleij@linaro.org>
> >> > Cc: Alexandre Courbot <gnurou@gmail.com>
> >> > Cc: Samuel Ortiz <sameo@linux.intel.com>
> >> > CC: Lee Jones <lee.jones@linaro.org>
> >> > Cc: linux-gpio@vger.kernel.org
> >> >
> >> > Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
> >>
> >> Already fixed in the GPIO tree.
> >
> > What does that mean?  That it doesn't need fixing here?
> 
> No. I think you already ACKed the patch fixing it in the GPIO
> tree...

No I don't need to apply the patch 'cos it's already fixed? Or, no
it's not already fixed and I need to apply the patch?

> There has been some misunderstanding and duplicate patches
> fixing already fixed problems are flying around.

I'm guessing from this commend that it _is_ already fixed and I _do
not_ need to apply this patch.

So for now I'm not applying this patch unless told otherwise.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
