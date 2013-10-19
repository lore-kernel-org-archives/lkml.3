Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab3JSQct (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 12:32:49 -0400
Received: from sirius.lasnet.de ([78.47.116.19]:58698 "EHLO sirius.lasnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753204Ab3JSQcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 12:32:47 -0400
X-Greylist: delayed 1810 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Oct 2013 12:32:47 EDT
Message-ID: <1382198544.22609.8.camel@polaris.local>
From: Jan =?ISO-8859-1?Q?L=FCbbe?= <jlu@pengutronix.de>
To: Tony Lindgren <tony@atomide.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>
Cc: Zubair Lutfullah <zubair.lutfullah@gmail.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org
Date: Sat, 19 Oct 2013 18:02:24 +0200
In-Reply-To: <20130821075828.GZ7656@atomide.com>
References: <1373901928-19605-1-git-send-email-zubair.lutfullah@gmail.com>
	 <20130821075828.GZ7656@atomide.com>
Organization: Pengutronix
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] typo fixes (coordiante -> coordinate) in am335x
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-21 at 00:58 -0700, Tony Lindgren wrote:
> * Zubair Lutfullah <zubair.lutfullah@gmail.com> [130715 08:33]:
> > Did a grep for coordiante and replaced them all
> > with coordinate.
> > 
> > This applies to the mfd-next tree.
> 
> This should be safe to apply via the MFD tree as a non-critical
> fix assuming the bootloaders are not yet using this:
> 
> Acked-by: Tony Lindgren <tony@atomide.com>

It seems this didn't get applied. It fixes the touchscreen on a
BeagleBone black with the 7" LCD and we should avoid having people use
the wrong binding.

Samuel or Lee: Could you take this patch?

Thanks,
Jan Lübbe

