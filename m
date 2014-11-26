Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbaKZR1a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 12:27:30 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:48884 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbaKZR12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 12:27:28 -0500
Date: Wed, 26 Nov 2014 12:27:27 -0500 (EST)
Message-Id: <20141126.122727.1791815907895724977.davem@davemloft.net>
To: viro@ZenIV.linux.org.uk
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 01/17] new helper: skb_copy_and_csum_datagram_msg()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141125205911.GA29748@ZenIV.linux.org.uk>
References: <1416924151-28698-1-git-send-email-viro@ZenIV.linux.org.uk>
	<20141125.142820.78809050565547546.davem@davemloft.net>
	<20141125205911.GA29748@ZenIV.linux.org.uk>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Nov 2014 09:27:28 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ZenIV.linux.org.uk>
Date: Tue, 25 Nov 2014 20:59:11 +0000

> On Tue, Nov 25, 2014 at 02:28:20PM -0500, David Miller wrote:
>> 
>> Al, this series looks fine to me, do you have a tree I can pull
>> it from?
> 
> Er...  Same as the last time?
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-davem
> 
> and there's more fun stuff in #iov_iter-net in the same tree, but that's
> the next batch...

Pulled, thanks Al.
