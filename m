Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab3J3NRo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 09:17:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44711 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932Ab3J3NRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 09:17:43 -0400
Date: Wed, 30 Oct 2013 06:19:42 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peng Tao <bergwolf@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andreas Dilger <andreas.dilger@intel.com>
Subject: Re: [PATCH 1/4] staging/lustre/llite: cache jobid in lu_env
Message-ID: <20131030131942.GC30087@kroah.com>
References: <1383132636-8952-1-git-send-email-bergwolf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383132636-8952-1-git-send-email-bergwolf@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 07:30:33PM +0800, Peng Tao wrote:
> We will switch to find jobid from /proc/self/environ and we need an
> extra memory copy to do it, so let's cache it in lu_env.
> It is then copied from lu_env to ll_inode_info upon every read/write.

What does this mean?

And you better not be reading proc values from within the kernel...

greg k-h
