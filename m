Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937656Ab3DIK34 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 06:29:56 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:40619 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760610Ab3DIK3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 06:29:55 -0400
Date: Tue, 9 Apr 2013 11:29:49 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Subject: Re: [PATCH 1/2] mfd: db8500-prcmu: Return early if the TCPM cannot
 be located
Message-ID: <20130409102949.GC25316@gmail.com>
References: <1365071941-23475-1-git-send-email-lee.jones@linaro.org>
 <20130409100510.GP24058@zurbaran>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130409100510.GP24058@zurbaran>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Apr 2013, Samuel Ortiz wrote:

> Hi Lee,
> 
> On Thu, Apr 04, 2013 at 11:39:00AM +0100, Lee Jones wrote:
> > Currently we check to see if we obtained the Tightly Coupled Program
> > Memory (TCPM) base and only execute the code within the check if we
> > have it. It's more traditional to return early if we don't have it.
> > This way we can flatten most of the function's code down to a single
> > tab spacing.
> > 
> > Cc: Samuel Ortiz <sameo@linux.intel.com>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/mfd/db8500-prcmu.c |   40 +++++++++++++++++++++-------------------
> >  1 file changed, 21 insertions(+), 19 deletions(-)
> I had to apply this one manually, please check if it was done correctly from
> my mfd-next tree.

Yes, looks good.

I think it was only 'db8500_prcmu_early_init()' and the line numbers
which confused it.

Kind regards,
Lee

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
