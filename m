Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678Ab3HWRBl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 13:01:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58567 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052Ab3HWRBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 13:01:40 -0400
Date: Fri, 23 Aug 2013 10:01:38 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Lidza Louina <lidza.louina@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: [PATCH -next] staging: dgnc: driver.c: Add missing #include
 <linux/slab.h>
Message-ID: <20130823170137.GA31358@kroah.com>
References: <1377260629-1696-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1377260629-1696-1-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 02:23:49PM +0200, Geert Uytterhoeven wrote:
> m68k/sparc64 allmodconfig:
> 
> drivers/staging/dgnc/dgnc_driver.c: In function ‘dgnc_cleanup_board’:
> drivers/staging/dgnc/dgnc_driver.c:459: error: implicit declaration of function ‘kfree’
> drivers/staging/dgnc/dgnc_driver.c: In function ‘dgnc_driver_kzmalloc’:
> drivers/staging/dgnc/dgnc_driver.c:905: error: implicit declaration of function ‘kmalloc’
> drivers/staging/dgnc/dgnc_driver.c:905: warning: initialization makes pointer from integer without a cast
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

This already went into my tree yesterday, so all should be good now.

thanks,

greg k-h
