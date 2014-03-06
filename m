Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbaCFWQW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 17:16:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36031 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbaCFWQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 17:16:20 -0500
Date: Thu, 6 Mar 2014 14:18:06 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Todza Louina <lidza.louina@gmail.com>,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: Re: [PATCH 1/3] staging: dgap: remove unneeded status variables
Message-ID: <20140306221806.GA30494@kroah.com>
References: <20140225005154.GA22937@kroah.com>
 <1393794488-12909-1-git-send-email-khoroshilov@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393794488-12909-1-git-send-email-khoroshilov@ispras.ru>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2014 at 01:08:06AM +0400, Alexey Khoroshilov wrote:
> dgap_driver_start and dgap_Major_Control_Registered are used
> to keep status of initialization of the driver as a whole and its "Major Control".
> But the code that checks them is executed once on module init/unload.
> That makes no sense in these variables as far as their values are predictable
> at any time.
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>  drivers/staging/dgap/dgap.c | 97 ++++++++++++++++++++-------------------------
>  1 file changed, 42 insertions(+), 55 deletions(-)

Due to other recent changes in this driver, none of these patches apply
anymore :(

Can you please redo them against my latest tree so that I can apply
them?

thanks,

greg k-h
