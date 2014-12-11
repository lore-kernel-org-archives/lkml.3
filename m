Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235AbaLKOpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 09:45:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41188 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757039AbaLKOpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 09:45:22 -0500
Date: Thu, 11 Dec 2014 09:45:19 -0500
From: Greg KH <gregkh@linuxfoundation.org>
To: Ganesh Mahendran <opensource.ganesh@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs/debugfs: add get/set for atomic_long types
Message-ID: <20141211144519.GA3509@kroah.com>
References: <1418302030-11428-1-git-send-email-opensource.ganesh@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418302030-11428-1-git-send-email-opensource.ganesh@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 08:47:10PM +0800, Ganesh Mahendran wrote:
> debugfs currently can not create attributes that set/get
> atomic_long_t values.
> 
> This patch adds support for this through a new
> debugfs_create_atomic_long_t() function.
> 
> Signed-off-by: Ganesh Mahendran <opensource.ganesh@gmail.com>
> ---
>  fs/debugfs/file.c       |   45 +++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/debugfs.h |    2 ++
>  2 files changed, 47 insertions(+)

Do you have kernel code that depends on this?

It's the middle of the merge window, so this will have to wait until
after 3.19-rc1, ok?

thanks,

greg k-h
