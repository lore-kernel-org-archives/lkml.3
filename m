Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab3LCQ71 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 11:59:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52330 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700Ab3LCQ70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 11:59:26 -0500
Date: Tue, 3 Dec 2013 09:00:28 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peng Tao <bergwolf@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andreas Dilger <andreas.dilger@intel.com>
Subject: Re: [PATCH 7/9] staging/lustre/llite: remove ll_file_get_iov_count
Message-ID: <20131203170028.GA9063@kroah.com>
References: <1386081729-9481-1-git-send-email-bergwolf@gmail.com>
 <1386081729-9481-10-git-send-email-bergwolf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386081729-9481-10-git-send-email-bergwolf@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 10:42:06PM +0800, Peng Tao wrote:
> It exactly copies generic_segment_checks() except wrongly calling
> access_ok(VERIFY_READ) for aio read range. Drop it and just call
> generic_segment_checks() instead.
> 
> Signed-off-by: Peng Tao <bergwolf@gmail.com>
> Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
> ---
>  drivers/staging/lustre/lustre/llite/file.c |   36 ++--------------------------
>  1 file changed, 2 insertions(+), 34 deletions(-)

This patch breaks the build, in numerous ways, which means you didn't
even build test this patch.

PLEASE be more careful, it's getting such that I really dread seeing
these patches show up in my inbox...

greg k-h
