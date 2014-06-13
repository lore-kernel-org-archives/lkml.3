Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408AbaFMHx0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 03:53:26 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56790 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbaFMHxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 03:53:25 -0400
Date: Fri, 13 Jun 2014 00:53:22 -0700 (PDT)
Message-Id: <20140613.005322.2144989764990353623.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: johannes.berg@intel.com, emmanuel.grumbach@intel.com,
        linville@tuxdriver.com, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ilw@linux.intel.com
Subject: Re: [GIT] Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+55aFy=CThoSKAJ6J3Jt-SJDkiGzwg=5tdF7_g+vyTEoPFzMQ@mail.gmail.com>
References: <20140612.121445.484288603919840829.davem@davemloft.net>
	<CA+55aFy=CThoSKAJ6J3Jt-SJDkiGzwg=5tdF7_g+vyTEoPFzMQ@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 13 Jun 2014 00:53:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 12 Jun 2014 23:48:57 -0700

> On Thu, Jun 12, 2014 at 12:14 PM, David Miller <davem@davemloft.net> wrote:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master
> 
> Hmm. I get *lots* of the appended messages from iwlwifi now. Things
> still seem to work, but ...
> 
> This is a Haswell laptop with bog-standard intel wireless:
> 
>   01:00.0 Network controller: Intel Corporation Wireless 7260 (rev 6b)
> 
> Any ideas?

Tom Herbert posted some checksumming fixes today, they might do the
trick.

I'll push them to you tomorrow.

For reference:

http://patchwork.ozlabs.org/patch/359390/
http://patchwork.ozlabs.org/patch/359391/
http://patchwork.ozlabs.org/patch/359392/
http://patchwork.ozlabs.org/patch/359393/
