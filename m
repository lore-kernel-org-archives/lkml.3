Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727AbaGMWmY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 18:42:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54576 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbaGMWmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 18:42:18 -0400
Date: Sun, 13 Jul 2014 15:46:48 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Joerg C. Meyer" <joerg@meyer.homedns.org>
Cc: chenweilong@huawei.com, davem@davemloft.net, sachin.kamat@linaro.org,
        dingtianhong@huawei.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8821ae: fix coding style issues in cam.c Fix
 all coding style error and warnings in cam.c reported by checkpatch.pl
Message-ID: <20140713224648.GB16220@kroah.com>
References: <1405288077-25513-1-git-send-email-joerg@meyer.homedns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405288077-25513-1-git-send-email-joerg@meyer.homedns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 13, 2014 at 11:47:57PM +0200, Joerg C. Meyer wrote:
> Signed-off-by: Joerg C. Meyer <joerg@meyer.homedns.org>

Your changelog body ended up in the Subject: line (that happens if you
don't put a blank line after the first line in your git commit.

Also, you don't say _what_ issues you fixed here, please be specific.

And if you fix more than one "type" of thing, please break that up into
multiple patches, as you are only allowed to do one-thing-per-patch.

Care to try this again?

thanks,

greg k-h
