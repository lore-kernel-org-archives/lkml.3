Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061AbaFFGq5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 02:46:57 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:57592 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaFFGqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 02:46:55 -0400
Date: Fri, 6 Jun 2014 07:46:49 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Kevin Hilman <khilman@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Rob Herring <robh@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>
Subject: Re: [PATCH-next] mfd: ab8500: fix dt irq mapping
Message-ID: <20140606064649.GJ24240@lee--X1>
References: <1401726478-14879-1-git-send-email-grygorii.strashko@ti.com>
 <CACRpkda7EEJNmfjHseQP9ChQ+OJf62qe=aBy3FJ-EFPGO1r6cg@mail.gmail.com>
 <CAGa+x85hBhwff_2gp8Wf+MGHUypC_qaa5AgeQMfjVffCZnbrRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGa+x85hBhwff_2gp8Wf+MGHUypC_qaa5AgeQMfjVffCZnbrRQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Jun 2014, Kevin Hilman wrote:
> On Tue, Jun 3, 2014 at 4:21 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> > On Mon, Jun 2, 2014 at 6:27 PM, Grygorii Strashko
> > <grygorii.strashko@ti.com> wrote:
> >
> >> The AD8500 defines itself as interrupt-controller in DT,
> >> but it doesn't assign DT node to IRQ domain when creates it.
> >> As result, of_irq_xx() helpers don't work because they can't
> >> find necessary IRQ domain.
> >>
> >> Hence, fix it by assigning AD8500 core device DT node to IRQ
> >> domain when it's created.
> >>
> >> This patch fixes STE u8500 Snowball boot failure reported by Kevin Hilman
> >> https://lkml.org/lkml/2014/5/27/624
> >>
> >> Cc: Samuel Ortiz <sameo@linux.intel.com>
> >> Cc: Lee Jones <lee.jones@linaro.org>
> >> Cc: Rob Herring <robh@kernel.org>
> >> Cc: Grant Likely <grant.likely@linaro.org>
> >> Cc: Thierry Reding <thierry.reding@gmail.com>
> >> Reported-and-tested-by: Kevin Hilman <khilman@linaro.org>
> >> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> >
> > Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> 
> Anyone picking this one up?  It's still broken in -next, and will be
> needed for v3.16.

I'm going to pull it in to mfd-for-fixes, as mfd-for-next has already
been sent to Linus.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
