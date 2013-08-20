Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466Ab3HTGsp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 02:48:45 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36369 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab3HTGsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 02:48:43 -0400
Date: Mon, 19 Aug 2013 23:48:40 -0700 (PDT)
Message-Id: <20130819.234840.1640929202046409588.davem@davemloft.net>
To: casey@schaufler-ca.com
Cc: amwang@redhat.com, netdev@vger.kernel.org, james.l.morris@oracle.com,
        sds@tycho.nsa.gov, eparis@parisplace.org, pmoore@redhat.com,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [Patch net-next v3 9/9] selinux: use generic union inet_addr
From: David Miller <davem@davemloft.net>
In-Reply-To: <5212915F.20905@schaufler-ca.com>
References: <52127336.3080209@schaufler-ca.com>
	<20130819.125026.636442915180863272.davem@davemloft.net>
	<5212915F.20905@schaufler-ca.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 19 Aug 2013 23:48:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Casey Schaufler <casey@schaufler-ca.com>
Date: Mon, 19 Aug 2013 14:42:55 -0700

> On 8/19/2013 12:50 PM, David Miller wrote:
>> It's so that you can pass a generic ipv4/ipv6 address blob into
>> things like printf formatting, and since there is an address family
>> member present, it knows what's in there and therefore one printf
>> format specifier can handle both ipv4 and ipv6 addresses.
> 
> The patch message needs to say that, then.

Actually, that belongs in the "0/N" posting, the contents of which
will end up in the merge commit should I apply the series.
