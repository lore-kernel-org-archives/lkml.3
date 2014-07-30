Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117AbaG3Doj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 23:44:39 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51890 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088AbaG3Doh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 23:44:37 -0400
Date: Tue, 29 Jul 2014 20:44:34 -0700 (PDT)
Message-Id: <20140729.204434.497235655726897367.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140730103628.234a4036@canb.auug.org.au>
References: <20140729.165532.599552078692796545.davem@davemloft.net>
	<20140730103628.234a4036@canb.auug.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 29 Jul 2014 20:44:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 30 Jul 2014 10:36:28 +1000

> On Tue, 29 Jul 2014 16:55:32 -0700 (PDT) David Miller <davem@davemloft.net> wrote:
>>
>> Oliver Neukum (2):
>>       cdc_subset: deal with a device that needs reset for timeout
> 
> This commit causes a build failure on arm (at least).  See my
> linux-next email about this.

Linus can you just revert that commit after you pull from me for now?

Thanks.
