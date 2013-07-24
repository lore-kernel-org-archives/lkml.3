Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab3GXTpI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 15:45:08 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:34414 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab3GXTpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 15:45:06 -0400
Date: Wed, 24 Jul 2013 12:45:04 -0700 (PDT)
Message-Id: <20130724.124504.1663757440011643606.davem@davemloft.net>
To: luis.henriques@canonical.com
Cc: ben@decadent.org.uk, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, shangw@linux.vnet.ibm.com
Subject: Re: [40/85] net/tg3: Avoid delay during MMIO access
From: David Miller <davem@davemloft.net>
In-Reply-To: <87zjtbzz8j.fsf@canonical.com>
References: <lsq.1374674565.832521875@decadent.org.uk>
	<87zjtbzz8j.fsf@canonical.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 24 Jul 2013 12:45:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Luis Henriques <luis.henriques@canonical.com>
Date: Wed, 24 Jul 2013 17:42:04 +0100

> I believe you didn't want to have these two invocations to the
> pci_channel_offline() function.  i guess you wanted to have one of
> these moved to the other branch of the 'if' statement.
> 
> [ btw, I've just replied to an email by David S. Miller about his
>   backport to 3.4 (and 3.2) of this commit. ]

Yes, indeed, both of these backports were done incorrectly.
