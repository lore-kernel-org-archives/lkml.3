Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965003Ab3GLNvj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 09:51:39 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:63136 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964861Ab3GLNvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 09:51:38 -0400
Date: Fri, 12 Jul 2013 14:51:33 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] MFD: twl6040: Cleanup in early error handling in
 probe function
Message-ID: <20130712135133.GN25601@gmail.com>
References: <1373628724-11397-1-git-send-email-peter.ujfalusi@ti.com>
 <1373628724-11397-3-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1373628724-11397-3-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jul 2013, Peter Ujfalusi wrote:

> The err: label is not needed we can just return instead of the jump there.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
>  drivers/mfd/twl6040.c | 14 +++++---------
>  1 file changed, 5 insertions(+), 9 deletions(-)

Nice little clean-up. Applied, thanks.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
