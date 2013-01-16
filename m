Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097Ab3APLH6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 06:07:58 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:44684 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474Ab3APLH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 06:07:56 -0500
Date: Wed, 16 Jan 2013 11:07:51 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Anmar Oueja <anmar.oueja@linaro.org>, stable@kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: Re: [PATCH v2] mfd: db8500-prcmu: fix irqdomain usage
Message-ID: <20130116110751.GN9379@gmail.com>
References: <1355995215-6273-1-git-send-email-linus.walleij@stericsson.com>
 <CACRpkdaV3VvhkOQ1Byvqc23oiONddcLVtKnRQbEA9q0U0YW4cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdaV3VvhkOQ1Byvqc23oiONddcLVtKnRQbEA9q0U0YW4cg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jan 2013, Linus Walleij wrote:

> On Thu, Dec 20, 2012 at 10:20 AM, Linus Walleij
> <linus.walleij@stericsson.com> wrote:
> 
> > From: Linus Walleij <linus.walleij@linaro.org>
> >
> > This fixes two issues with the DB8500 PRCMU irqdomain:
> > - You have to state the irq base 0 to get a linear domain
> >   for the DT case from irq_domain_add_simple()
> > - The irqdomain was not used to translate the initial irq
> >   request using irq_create_mapping() making the linear
> >   case fail as it was lacking a proper descriptor.
> >
> > I took this opportunity to fix two lines of whitespace
> > errors in related code as I was anyway messing around with
> > it.
> >
> > Cc: stable@kernel.org
> > Cc: Lee Jones <lee.jones@linaro.org>
> > Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

I thought you said I Acked this already?

Just in case: Acked-by Lee Jones <lee.jones@linaro.org>

> Sam, this regression fix has been around for a month soon,
> could you please apply it if there are no problems with it?

Definitely need this soon Sam.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
