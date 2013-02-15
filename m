Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080Ab3BOSVX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 13:21:23 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:39242 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756170Ab3BOSVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 13:21:22 -0500
Date: Fri, 15 Feb 2013 10:21:19 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Robert Berger <git.rber@gmail.com>
Cc: devel@driverdev.osuosl.org, konrad.wilk@oracle.com,
        sjenning@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        xiaoguangrong@linux.vnet.ibm.com, minchan@kernel.org,
        rber.git@gmail.com,
        Robert Berger <rber.git@ReliableEmbeddedSystems.com>
Subject: Re: [PATCH] staging/zcache fixed some checkpatch issues
Message-ID: <20130215182119.GA23225@kroah.com>
References: <1360925580-18633-1-git-send-email-rber.git@ReliableEmbeddedSystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360925580-18633-1-git-send-email-rber.git@ReliableEmbeddedSystems.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 12:53:00PM +0200, Robert Berger wrote:
> tmem.c:76: ERROR: "foo*bar" should be "foo *bar"
> zcache-main.c:2057: WARNING: quoted string split across lines
> zcache-main.c:2059: WARNING: Prefer pr_warn(... to pr_warning(...
> zcache-main.c:2068: WARNING: quoted string split across lines
> zcache-main.c:2070: WARNING: Prefer pr_warn(... to pr_warning(...
> 
> Signed-off-by: Robert Berger <rber.git@ReliableEmbeddedSystems.com>
> ---
>  drivers/staging/zcache/tmem.c        |    2 +-
>  drivers/staging/zcache/zcache-main.c |   10 ++++------
>  2 files changed, 5 insertions(+), 7 deletions(-)

This patch fails to apply to my tree for some reason, can you redo it
against the latest linux-next tree and resend?

thanks,

greg k-h
