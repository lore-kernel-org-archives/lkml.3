Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab3A1KWe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 05:22:34 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:55186 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270Ab3A1KWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 05:22:30 -0500
Date: Mon, 28 Jan 2013 10:22:23 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Subject: Re: [PATCH 09/26] mfd: ab8500-debugfs: Provide a means for a user
 subscribe to IRQs
Message-ID: <20130128102223.GA18212@gmail.com>
References: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
 <1358254566-12419-10-git-send-email-lee.jones@linaro.org>
 <20130127235259.GO1174@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130127235259.GO1174@sortiz-mobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2013, Samuel Ortiz wrote:

> Hi Lee,
> 
> On Tue, Jan 15, 2013 at 12:55:49PM +0000, Lee Jones wrote:
> > Allow users to subscribe to and view IRQ events live from debugfs.
> I seem to remember that I got a similar patch some time ago for the same
> purpose and my answer was: Please use a UIO driver for this. There already is
> such driver, it's uio_pdrv_genirq. What your debugfs registration entry could
> do is adding a platform device for the specific interrupt number. This would
> avoid the irq handler registration and the sysfs entry creation, both things I
> believe are not very elegant and open coded. It also gives you an IRQ count
> implementation.
> Ideally, the UIO framework could be improved to support IRQ ranges (through
> IRQ domains) instead of the current single interrupt number.
> 
> Have you considered going through that path ?

I'm going to have to put this patch-set in the bin. Pulling this
patch, causes lots of conflicts to the remaining patches in the
set.

I'll start again from scratch and find another way to sync the ab* MFD
drivers. I might even have to do it manually i.e. throw out all
commit history and upstream it as my own patches pulled in from diffs.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
