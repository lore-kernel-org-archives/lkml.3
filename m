Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906AbaKUR0Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 12:26:24 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:36248 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758595AbaKUR0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 12:26:22 -0500
Date: Fri, 21 Nov 2014 12:26:15 -0500 (EST)
Message-Id: <20141121.122615.1091044030302005883.davem@davemloft.net>
To: viro@ZenIV.linux.org.uk
Cc: torvalds@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, target-devel@vger.kernel.org,
        nab@linux-iscsi.org, hch@infradead.org
Subject: Re: [RFC] situation with csum_and_copy_... API
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141120.182339.972861702759954603.davem@davemloft.net>
References: <20141119.165340.2162829993279387495.davem@davemloft.net>
	<20141120214753.GR7996@ZenIV.linux.org.uk>
	<20141120.182339.972861702759954603.davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 21 Nov 2014 09:26:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Thu, 20 Nov 2014 18:23:39 -0500 (EST)

> From: Al Viro <viro@ZenIV.linux.org.uk>
> Date: Thu, 20 Nov 2014 21:47:53 +0000
> 
>> On Wed, Nov 19, 2014 at 04:53:40PM -0500, David Miller wrote:
>> 
>>> Pulled, thanks Al.
>> 
>> Umm...  Not in net-next.git#master...
> 
> Sorry, I may have done my usual: pull at the office compute, fire up
> build testing, go home without pushing back out to kernel.org
> 
> :-/
> 
> I'll check first thing tomorrow morning.

I've resolved this now, sorry for the inconvenience Al.
