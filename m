Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbaCFWRF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 17:17:05 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:34102 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaCFWQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 17:16:58 -0500
Date: Thu, 06 Mar 2014 17:16:56 -0500 (EST)
Message-Id: <20140306.171656.1597596195712774395.davem@davemloft.net>
To: dhowells@redhat.com
Cc: netdev@vger.kernel.org, tim@electronghost.co.uk,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] AF_RXRPC fixes and development [ver #2]
From: David Miller <davem@davemloft.net>
In-Reply-To: <8007.1394144113@warthog.procyon.org.uk>
References: <20140306.143719.2217501178599478723.davem@davemloft.net>
	<20140306124614.16645.50744.stgit@warthog.procyon.org.uk>
	<8007.1394144113@warthog.procyon.org.uk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Mar 2014 14:16:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Thu, 06 Mar 2014 22:15:13 +0000

> David Miller <davem@davemloft.net> wrote:
> 
>> > Here are some AF_RXRPC fixes (to tag rxrpc-20140226):
>>  ...
>> > And development patches (to tag rxrpc-devel-20140304):
>> 
>> A mix of both bug fixes and new features....
> 
> I did ask whether you wanted them in one or preferred them separate...

It depends upon whether you want the bug fixes to go into Linus's
tree for the current release or not.

If you do, submit just the bug fixes against 'net'

Then when I next merge 'net' into 'net-next', submit the feature
patches.
