Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbaBYAuW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 19:50:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52575 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbaBYAuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 19:50:21 -0500
Date: Mon, 24 Feb 2014 16:51:54 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Todza Louina <lidza.louina@gmail.com>, devel@driverdev.osuosl.org,
        ldv-project@linuxtesting.org, driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] staging: dgap: remove unneeded status variables
Message-ID: <20140225005154.GA22937@kroah.com>
References: <1393186913-4687-1-git-send-email-khoroshilov@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393186913-4687-1-git-send-email-khoroshilov@ispras.ru>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 12:21:51AM +0400, Alexey Khoroshilov wrote:
> dgap_driver_start and dgap_Major_Control_Registered are used
> to keep status of initialization of the driver as a whole and its "Major Control".
> But the code that checks them is executed once on module init/unload.
> That makes no sense in these variables as far as their values are predictable
> at any time.
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>  drivers/staging/dgap/dgap_driver.c | 105 ++++++++++++++++---------------------
>  1 file changed, 46 insertions(+), 59 deletions(-)

This file is no longer in my tree, as the driver has been merged to one
file.  Can you please redo it against my latest staging-next branch of
my staging.git tree and resend the series so that I can apply them?

thanks,

greg k-h
