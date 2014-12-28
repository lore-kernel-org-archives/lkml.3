Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888AbaL1PdO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 10:33:14 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:38932 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbaL1PdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 10:33:14 -0500
Date: Sun, 28 Dec 2014 15:33:11 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Evgeniy Dushistov <dushistov@mail.ru>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] fs/ufs/super.c: remove unnecessary casting
Message-ID: <20141228153311.GI22149@ZenIV.linux.org.uk>
References: <1419780509-4582-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419780509-4582-1-git-send-email-fabf@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 28, 2014 at 04:28:29PM +0100, Fabian Frederick wrote:
> Fix the following coccinelle warning:
> fs/ufs/super.c:1418:7-28: WARNING: casting value returned by memory
> allocation function to (struct ufs_inode_info *) is useless.

... except that it makes allocations harder to grep for.  IOW, it's not
obviously an improvement and should be up to maintainer of the code in
question.
