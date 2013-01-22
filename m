Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978Ab3AVA1j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 19:27:39 -0500
Received: from mga11.intel.com ([192.55.52.93]:41283 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090Ab3AVA1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 19:27:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,510,1355126400"; 
   d="scan'208";a="276724163"
Date: Tue, 22 Jan 2013 01:27:31 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Anmar Oueja <anmar.oueja@linaro.org>,
        stable@kernel.org, Lee Jones <lee.jones@linaro.org>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: Re: [PATCH v2] mfd: db8500-prcmu: fix irqdomain usage
Message-ID: <20130122002731.GB7409@sortiz-mobl>
References: <1355995215-6273-1-git-send-email-linus.walleij@stericsson.com>
 <CACRpkdaV3VvhkOQ1Byvqc23oiONddcLVtKnRQbEA9q0U0YW4cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdaV3VvhkOQ1Byvqc23oiONddcLVtKnRQbEA9q0U0YW4cg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Mon, Jan 14, 2013 at 11:26:09PM +0100, Linus Walleij wrote:
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
> 
> Sam, this regression fix has been around for a month soon,
> could you please apply it if there are no problems with it?
Applied to my for-linus branch. I'll send a 3.8 fixes pull request soon.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
