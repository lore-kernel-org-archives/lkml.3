Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbaBNTMT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 14:12:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44918 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbaBNTMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 14:12:18 -0500
Date: Fri, 14 Feb 2014 11:13:38 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: [char-misc-next 3/4] mei: add mei_hbuf_acquire wrapper
Message-ID: <20140214191338.GA423@kroah.com>
References: <1392234114-4926-1-git-send-email-tomas.winkler@intel.com>
 <1392234114-4926-4-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392234114-4926-4-git-send-email-tomas.winkler@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 09:41:53PM +0200, Tomas Winkler wrote:
> A client has to acquire host buffer
> before writing, we add lock like wrapper
> to replace the code snippet
> 
> if (dev->hbuf_is_ready)
>         dev->hbuf_is_ready = false;
> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>  drivers/misc/mei/amthif.c    |  7 +-----
>  drivers/misc/mei/client.c    | 56 ++++++++++++++++++++++++++++----------------
>  drivers/misc/mei/hw-me.c     |  2 ++
>  drivers/misc/mei/hw-txe.c    | 17 +++++---------
>  drivers/misc/mei/interrupt.c |  6 ++---
>  drivers/misc/mei/mei_dev.h   |  2 ++
>  drivers/misc/mei/wd.c        | 14 +++++------
>  7 files changed, 57 insertions(+), 47 deletions(-)

This patch fails to apply:
	checking file drivers/misc/mei/amthif.c
	checking file drivers/misc/mei/client.c
	Hunk #4 FAILED at 681.
	Hunk #5 succeeded at 815 (offset -2 lines).
	Hunk #6 succeeded at 848 (offset -2 lines).
	1 out of 6 hunks FAILED
	checking file drivers/misc/mei/hw-me.c
	checking file drivers/misc/mei/hw-txe.c
	checking file drivers/misc/mei/interrupt.c
	checking file drivers/misc/mei/mei_dev.h
	checking file drivers/misc/mei/wd.c

