Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbaBGQny (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 11:43:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57498 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbaBGQnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 11:43:51 -0500
Date: Fri, 7 Feb 2014 08:45:00 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Wang YanQing <udknight@gmail.com>, jslaby@suse.cz, airlied@redhat.com,
        akpm@linux-foundation.org, kilobyte@angband.pl,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vt: initialize con_driver->node in con_init
Message-ID: <20140207164500.GB32655@kroah.com>
References: <20131230031102.GA4424@udknight>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131230031102.GA4424@udknight>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 30, 2013 at 11:11:02AM +0800, Wang YanQing wrote:
> Commit 6db4063c5b72b46e9793b0f141a7a3984ac6facf
> ("[PATCH] VT binding: Add sysfs control to the VT layer")
> add node item into struct con_driver.

That commit was almost a decade ago, is this patch really needed?

> This patch initialize con_driver->node in con_init.

You are saying what it does, not _why_ it is needed or why this change
is happening.

Please rewrite this with more information because as-is, I have no idea
why I should accept this patch.

thanks,

greg k-h
