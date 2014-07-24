Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759532AbaGXWJP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 18:09:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43511 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaGXWJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 18:09:14 -0400
Date: Thu, 24 Jul 2014 15:09:14 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Igor Bezukh <igbzkh@gmail.com>
Cc: devel@driverdev.osuosl.org, forest@alittletooquiet.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: vt6655: remove redundant comments from card.h
Message-ID: <20140724220914.GA26952@kroah.com>
References: <1406227814-12404-1-git-send-email-igbzkh@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406227814-12404-1-git-send-email-igbzkh@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 09:50:14PM +0300, Igor Bezukh wrote:
> Removed redundant comments from card.h header file.
> 
> Signed-off-by: Igor Bezukh <igbzkh@gmail.com>
> ---
>  drivers/staging/vt6655/80211hdr.h |    7 -------
>  drivers/staging/vt6655/80211mgr.h |   38 -------------------------------------
>  drivers/staging/vt6655/aes_ccmp.h |    9 ---------
>  drivers/staging/vt6655/baseband.h |   12 ------------
>  drivers/staging/vt6655/bssdb.h    |   25 ++----------------------
>  drivers/staging/vt6655/card.h     |   10 +---------
>  6 files changed, 3 insertions(+), 98 deletions(-)

Your subject does not match up with this diffstat :(

