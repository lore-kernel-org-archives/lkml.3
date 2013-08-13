Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758376Ab3HMRQx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 13:16:53 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:38742 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756904Ab3HMRQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 13:16:52 -0400
Date: Tue, 13 Aug 2013 18:16:44 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Zubair Lutfullah <zubair.lutfullah@gmail.com>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH] mfd: ti_am335x_tscadc: fix reg_cache in clr function
Message-ID: <20130813171644.GK15278@lee--X1>
References: <1376412056-20736-1-git-send-email-zubair.lutfullah@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1376412056-20736-1-git-send-email-zubair.lutfullah@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Aug 2013, Zubair Lutfullah wrote:

> Fixed reg_cache in the set function. But missed the clr function
> in the previous patch. This updates the clr function as well.
> 
> This applies after the previous fix I sent that Lee has accepted.
> mfd-next hasn't been updated yet.
> 
> 
> Zubair Lutfullah (1):
>   mfd: ti_am335x_tscadc: Update reg_cache variable in clr function
> 
>  drivers/mfd/ti_am335x_tscadc.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

I assume this is a 0/1 patch.

When you're sending a single patch, there's no need to send a front
page. Also, when you do send one, it's helpful to name the patches:

[PATCH 0/2] ...
[PATCH 1/2] ...
[PATCH 2/2] ...
... etc

Where 0/2 is the front page.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
