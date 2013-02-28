Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933130Ab3B1TIm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 14:08:42 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:64206 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805Ab3B1TIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 14:08:41 -0500
Date: Thu, 28 Feb 2013 11:08:39 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Omar Ramirez Luna <omar.ramirez@copitl.com>,
        Tony Lindgren <tony@atomide.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Joni Lapilainen <joni.lapilainen@gmail.com>
Subject: Re: [PATCH] tidspbridge: Fix compilation
Message-ID: <20130228190839.GD19428@kroah.com>
References: <1362073866-8462-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1362073866-8462-1-git-send-email-pali.rohar@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 06:51:06PM +0100, Pali Rohár wrote:
> Fix includes and use clk_prepare_enable/clk_disable_unprepare
> 
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> Signed-off-by: Joni Lapilainen <joni.lapilainen@gmail.com>
> ---
>  drivers/staging/tidspbridge/core/dsp-clock.c  |   16 ++++++++--------
>  drivers/staging/tidspbridge/core/tiomap3430.c |    2 ++
>  drivers/staging/tidspbridge/core/tiomap_io.c  |    2 ++
>  drivers/staging/tidspbridge/core/wdt.c        |    8 ++++----
>  4 files changed, 16 insertions(+), 12 deletions(-)

Fix compilation of what?  What broke?  What is the error message?  When
did it break?  In what tree does this need to go into?  Why am I asking
so many questions?

greg k-h
