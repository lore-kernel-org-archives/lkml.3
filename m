Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386AbaKYU7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 15:59:16 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:45273 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbaKYU7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 15:59:14 -0500
Date: Tue, 25 Nov 2014 20:59:11 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 01/17] new helper: skb_copy_and_csum_datagram_msg()
Message-ID: <20141125205911.GA29748@ZenIV.linux.org.uk>
References: <20141125024018.GH7996@ZenIV.linux.org.uk>
 <1416924151-28698-1-git-send-email-viro@ZenIV.linux.org.uk>
 <20141125.142820.78809050565547546.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141125.142820.78809050565547546.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 02:28:20PM -0500, David Miller wrote:
> 
> Al, this series looks fine to me, do you have a tree I can pull
> it from?

Er...  Same as the last time?

git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-davem

and there's more fun stuff in #iov_iter-net in the same tree, but that's
the next batch...
