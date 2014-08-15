Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751630AbaHOP0n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 11:26:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40567 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbaHOP0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 11:26:41 -0400
Date: Fri, 15 Aug 2014 14:08:41 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Seunghun Lee <waydi1@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Lidza Louina <lidza.louina@gmail.com>,
        Mark Hounschell <markh@compro.net>
Subject: Re: [PATCH] staging: dgnc: remove DPR Macros and related codes.
Message-ID: <20140815060841.GA28534@kroah.com>
References: <1407850214-3678-1-git-send-email-waydi1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407850214-3678-1-git-send-email-waydi1@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 10:30:14PM +0900, Seunghun Lee wrote:
> In dgnc_drivers.h, DPR macro and DPR_* macros are defined but do nothing.
> 
> So remove them and related codes.
> 
> CC: Lidza Louina <lidza.louina@gmail.com>
> CC: Mark Hounschell <markh@compro.net>
> Signed-off-by: Seunghun Lee <waydi1@gmail.com>
> ---
>  drivers/staging/dgnc/dgnc_cls.c    |   63 +--------
>  drivers/staging/dgnc/dgnc_driver.c |   20 +--
>  drivers/staging/dgnc/dgnc_driver.h |   21 ---
>  drivers/staging/dgnc/dgnc_mgmt.c   |   23 ----
>  drivers/staging/dgnc/dgnc_neo.c    |  104 ++-------------
>  drivers/staging/dgnc/dgnc_tty.c    |  249 +++---------------------------------
>  6 files changed, 36 insertions(+), 444 deletions(-)

This conflicts with patches others have sent, can you refresh it after
next Tuesday or so when I catch up with the pending patches and can push
them out?

thanks,

greg k-h
