Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722Ab3KRVzN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 16:55:13 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:45236 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab3KRVzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 16:55:10 -0500
MIME-Version: 1.0
In-Reply-To: <62a00a45d2fc38d1881f153f35ba282e85d78a3e.1384518190.git.gamerh2o@gmail.com>
References: <62a00a45d2fc38d1881f153f35ba282e85d78a3e.1384518190.git.gamerh2o@gmail.com>
From: Mark Einon <mark.einon@gmail.com>
Date: Mon, 18 Nov 2013 21:54:54 +0000
Message-ID: <CANK3SE36i0+NQdEtuO+FFebDKtrBBM=RjzB4WqSun2o1FK3xpA@mail.gmail.com>
Subject: Re: [PATCH 1/4] staging: et131x: clean up code
To: ZHAO Gang <gamerh2o@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 08:27:58PM +0800, ZHAO Gang wrote:
> 1. change function name: et1310_phy_power_down -> et1310_phy_power_switch
> change function name to better describe its functionality.
>
> 2. as TODO file suggested, do this sort of things to reduce split lines
> struct fbr_lookup *fbr;
> fbr = rx_local->fbr[id];
> Then replace all the instances of "rx_local->fbr[id]" with fbr.
>
> 3. delete unnecessary variable in function et131x_init
> variable u32 numrfd is not necessary in this function.
>
> 4. some code style change
>
> Signed-off-by: ZHAO Gang <gamerh2o@gmail.com>
> ---
>  drivers/staging/et131x/et131x.c | 209 ++++++++++++++++++++--------------------
>  1 file changed, 103 insertions(+), 106 deletions(-)

Hi Zhao,

I'm a bit confused - these patches apply to the current head of
staging-next, but not on top of your previous two patches. I assume that
you're aiming to have these changes on top of your last two, so can you
please re-spin them to apply cleanly to the head of (staging-next + your
previous patches)?

Cheers,

Mark
