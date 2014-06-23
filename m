Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbaFWQPX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 12:15:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50924 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755642AbaFWQPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 12:15:21 -0400
Date: Mon, 23 Jun 2014 12:15:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 21/22] synclink_gt: Use pci_zalloc_consistent
Message-ID: <20140623161509.GC20288@kroah.com>
References: <cover.1403530604.git.joe@perches.com>
 <f09f13b8b57b40311b1aa8fa19267f4fed14a850.1403530604.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f09f13b8b57b40311b1aa8fa19267f4fed14a850.1403530604.git.joe@perches.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 06:41:49AM -0700, Joe Perches wrote:
> Remove the now unnecessary memset too.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/tty/synclink_gt.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
