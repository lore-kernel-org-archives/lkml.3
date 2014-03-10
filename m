Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468AbaCJMoJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 08:44:09 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:48430 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbaCJMoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 08:44:08 -0400
Date: Mon, 10 Mar 2014 12:44:02 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] mfd: syscon: Simplify syscon_match_pdevname()
Message-ID: <20140310124402.GB18494@lee--X1>
References: <1394449053-27818-1-git-send-email-shc_work@mail.ru>
 <20140310124327.GA18494@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140310124327.GA18494@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2014, Lee Jones wrote:

> > Since we do not want to add new platform IDs for the syscon driver,
> > there is no reason to iterate over IDs. This patch simplifies
> > syscon_match_pdevname() function to remove such iteration.
> > 
> > Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> > ---
> >  drivers/mfd/syscon.c | 7 -------
> >  1 file changed, 7 deletions(-)
> 
> Looks sane:
>   Acked-by: Lee Jones <lee.jones@linaro.org>

Whoops, sorry! I mean applied.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
