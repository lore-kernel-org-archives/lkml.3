Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbaEWSjO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 14:39:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43834 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbaEWSjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 14:39:12 -0400
Date: Fri, 23 May 2014 20:14:54 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: David Matlack <matlackdavid@gmail.com>
Cc: devel@driverdev.osuosl.org, charrer@alacritech.com,
        linux-kernel@vger.kernel.org, liodot@gmail.com
Subject: Re: [PATCH] staging: slicoss: fix use-after-free in slic_entry_probe
Message-ID: <20140523111454.GA3992@kroah.com>
References: <1400819147-14236-1-git-send-email-matlackdavid@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400819147-14236-1-git-send-email-matlackdavid@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 09:25:40PM -0700, David Matlack wrote:
> Fix a use-after-free bug that can cause a kernel oops. If
> slic_card_init fails then slic_entry_probe() (the pci probe()
> function for this device) will return error without cleaning
> up memory (including the registered netdev struct).
> 
> Signed-off-by: David Matlack <matlackdavid@gmail.com>
> ---
> This patch was originally sent here https://lkml.org/lkml/2014/5/6/10 with
> my google.com email address. But due to Google's recent change in DMARC
> policies, that patchset was silently dropped for at least some users
> (including my personal gmail account). So I'm sending it out now with
> my gmail.com account. Let me know if this is an issue. Thanks.

I think I've already applied all of these, if not, please let me know.

Also, you forgot to number these patches to let me know what order to
apply them in :(

thanks,

greg k-h
