Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701AbaBYExs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 23:53:48 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:49914 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbaBYExr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 23:53:47 -0500
Date: Mon, 24 Feb 2014 23:53:43 -0500 (EST)
Message-Id: <20140224.235343.1936318499491821387.davem@davemloft.net>
To: ben@decadent.org.uk
Cc: mcgrof@do-not-panic.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mcgrof@suse.com
Subject: Re: [PATCH] net: kdoc struct net_device flags and priv_flags
From: David Miller <davem@davemloft.net>
In-Reply-To: <1393294265.6823.154.camel@deadeye.wl.decadent.org.uk>
References: <1393287245-4549-1-git-send-email-mcgrof@do-not-panic.com>
	<1393294265.6823.154.camel@deadeye.wl.decadent.org.uk>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Feb 2014 20:53:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>
Date: Tue, 25 Feb 2014 02:11:05 +0000

> On Mon, 2014-02-24 at 16:14 -0800, Luis R. Rodriguez wrote:
>> From: "Luis R. Rodriguez" <mcgrof@suse.com>
>> 
>> ---
>>  include/uapi/linux/if.h | 201 +++++++++++++++++++++++++++++++++++-------------
>>  1 file changed, 149 insertions(+), 52 deletions(-)
>> 
>> diff --git a/include/uapi/linux/if.h b/include/uapi/linux/if.h
>> index d758163..1555623 100644
>> --- a/include/uapi/linux/if.h
>> +++ b/include/uapi/linux/if.h
> [...]
>> +/**
>> + * enum net_device_priv_flags - &struct net_device priv_flags
>> + *
>> + * These are the &struct net_device, they are only set internally
>> + * by drivers and used in the kernel but are invisible to userspace.
> [...]
> 
> Indeed, I wonder why they are in the UAPI header.  As userland doesn't
> have a legitimate use for them, maybe you could move them back to
> include/linux/if.h instead of bothering with adding macros?

They are visible to userspace via sysfs.

My memory may be bad, but I believe this has been brought up before.
