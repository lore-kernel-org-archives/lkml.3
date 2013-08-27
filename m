Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab3H0Kkn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 06:40:43 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:55094 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab3H0Kkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 06:40:42 -0400
Date: Tue, 27 Aug 2013 11:40:34 +0100
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com
Subject: Re: [PATCH 1/3] mfd: ab8500-debugfs: Apply a check for -ENOMEM after
 allocating memory for sysfs
Message-ID: <20130827104034.GA10210@lee--X1>
References: <1374243017-8515-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1374243017-8515-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Jul 2013, Lee Jones wrote:

> The AB8500 debugfs driver allocates memory for a new sysfs entry, but
> fails to apply the proper post-allocation checks. If the device were to
> run out of memory, the allocation would return NULL. Without the correct
> checks the driver will continue to populate NULL->[show|store|...],
> which would obviously cause a pointer dereference Oops.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mfd/ab8500-debugfs.c | 3 +++
>  1 file changed, 3 insertions(+)

These 3 patches have been on the MLs for quite some time now.

Tentatively applying all 3.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
