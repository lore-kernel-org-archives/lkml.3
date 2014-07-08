Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594AbaGHXeW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 19:34:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37925 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbaGHXeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 19:34:20 -0400
Date: Tue, 8 Jul 2014 16:38:45 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Daeseok Youn <daeseok.youn@gmail.com>,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH 1/1] staging: cxt1e1: remove null test before kfree
Message-ID: <20140708233844.GA18834@kroah.com>
References: <1404503895-32722-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404503895-32722-1-git-send-email-fabf@skynet.be>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2014 at 09:58:15PM +0200, Fabian Frederick wrote:
> Fix checkpatch warning:
> WARNING: kfree(NULL) is safe this check is probably not required
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Daeseok Youn <daeseok.youn@gmail.com>
> Cc: devel@driverdev.osuosl.org
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  drivers/staging/cxt1e1/pmcc4_drv.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)

This driver has been deleted in the tree, sorry.

greg k-h
