Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbaIBIOk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 04:14:40 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:58187 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341AbaIBIO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 04:14:27 -0400
Date: Tue, 2 Sep 2014 12:14:24 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrey Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] fs/notify: don't show f_handle if
 exportfs_encode_inode_fh failed
Message-ID: <20140902081424.GG10904@moon>
References: <1409644815-19367-1-git-send-email-avagin@openvz.org>
 <1409644815-19367-2-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409644815-19367-2-git-send-email-avagin@openvz.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 12:00:15PM +0400, Andrey Vagin wrote:
> Currently we handle only ENOSPC. In case of other errors the file_handle
> variable isn't filled properly and we will show a part of stack.
> 
> Cc: Cyrill Gorcunov <gorcunov@openvz.org>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Andrey Vagin <avagin@openvz.org>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
