Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592AbaIBIT4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 04:19:56 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:58698 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbaIBITx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 04:19:53 -0400
Date: Tue, 2 Sep 2014 12:19:50 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrey Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] fsnotify/fdinfo: use named constants instead of
 hardcoded values
Message-ID: <20140902081950.GA17159@moon>
References: <1409644815-19367-1-git-send-email-avagin@openvz.org>
 <20140902081408.GF10904@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140902081408.GF10904@moon>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 12:14:08PM +0400, Cyrill Gorcunov wrote:
> On Tue, Sep 02, 2014 at 12:00:14PM +0400, Andrey Vagin wrote:
> > MAX_HANDLE_SZ is equal to 128, but currently the size of pad is only 64
> > bytes, so exportfs_encode_inode_fh can return an error.
> > 
> > Cc: Cyrill Gorcunov <gorcunov@openvz.org>
> > Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Andrey Vagin <avagin@openvz.org>
> Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>

Btw, I think both are good candidates for @stable.
