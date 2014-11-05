Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751249AbaKEWNy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 17:13:54 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:48713 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbaKEWNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 17:13:52 -0500
Date: Wed, 05 Nov 2014 17:13:48 -0500 (EST)
Message-Id: <20141105.171348.1010570676094960613.davem@davemloft.net>
To: gregory.0xf0@gmail.com
Cc: netdev@vger.kernel.org, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org, carlos@redhat.com, eblake@redhat.com,
        galak@codeaurora.org, f.fainelli@gmail.com, xiyou.wangcong@gmail.com
Subject: Re: [PATCH] bridge: include in6.h in if_bridge.h for struct
 in6_addr
From: David Miller <davem@davemloft.net>
In-Reply-To: <1415128881-30183-1-git-send-email-gregory.0xf0@gmail.com>
References: <1415128881-30183-1-git-send-email-gregory.0xf0@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Nov 2014 14:13:52 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gregory Fong <gregory.0xf0@gmail.com>
Date: Tue,  4 Nov 2014 11:21:21 -0800

> if_bridge.h uses struct in6_addr ip6, but wasn't including the in6.h
> header.  Thomas Backlund originally sent a patch to do this, but this
> revealed a redefinition issue: https://lkml.org/lkml/2013/1/13/116
> 
> The redefinition issue should have been fixed by the following Linux
> commits:
> ee262ad827f89e2dc7851ec2986953b5b125c6bc inet: defines IPPROTO_* needed for module alias generation
> cfd280c91253cc28e4919e349fa7a813b63e71e8 net: sync some IP headers with glibc
> 
> and the following glibc commit:
> 6c82a2f8d7c8e21e39237225c819f182ae438db3 Coordinate IPv6 definitions for Linux and glibc
> 
> so actually include the header now.
> 
> Reported-by: Colin Guthrie <colin@mageia.org>
> Reported-by: Christiaan Welvaart <cjw@daneel.dyndns.org>
> Reported-by: Thomas Backlund <tmb@mageia.org>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Cong Wang <xiyou.wangcong@gmail.com>
> Cc: David Miller <davem@davemloft.net>
> Signed-off-by: Gregory Fong <gregory.0xf0@gmail.com>

Applied, thank you.
