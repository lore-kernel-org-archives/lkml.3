Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476AbaBKUYg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:24:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41220 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756021AbaBKUYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 15:24:32 -0500
Date: Tue, 11 Feb 2014 12:25:47 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: john.stultz@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpu: ion: fix sparse non static symbol warnings
Message-ID: <20140211202547.GA11684@kroah.com>
References: <2249537.0tqhh5qnLv@daeseok-laptop.cloud.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2249537.0tqhh5qnLv@daeseok-laptop.cloud.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 09:32:22AM +0900, Daeseok Youn wrote:
> >From 08b77be03927d450810c07d3a4440dc8c32fe766 Mon Sep 17 00:00:00 2001
> From: Daeseok Youn <daeseok.youn@gmail.com>
> Date: Mon, 10 Feb 2014 09:02:26 +0900
> Subject: [PATCH] gpu: ion: fix sparse non static symbol warnings
> 
> Fixes the following sparse warnings:
> 
> drivers/staging/android/ion/ion_dummy_driver.c:26:19:
>  warning: symbol 'idev' was not declared. Should it be static?
> drivers/staging/android/ion/ion_dummy_driver.c:27:17:
>  warning: symbol 'heaps' was not declared. Should it be static?
> drivers/staging/android/ion/ion_dummy_driver.c:29:6:
>  warning: symbol 'carveout_ptr' was not declared. Should it be static?
> drivers/staging/android/ion/ion_dummy_driver.c:30:6:
>  warning: symbol 'chunk_ptr' was not declared. Should it be static?
> drivers/staging/android/ion/ion_dummy_driver.c:32:26:
>  warning: symbol 'dummy_heaps' was not declared. Should it be static?
> drivers/staging/android/ion/ion_dummy_driver.c:59:26:
>  warning: symbol 'dummy_ion_pdata' was not declared. Should it be static?
> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>

This patch has already been made in my tree, please always work against
linux-next to prevent duplication of work.

thanks,

greg k-h
