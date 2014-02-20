Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbaBTSec (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 13:34:32 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:57905 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315AbaBTSea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 13:34:30 -0500
Date: Thu, 20 Feb 2014 13:34:29 -0500 (EST)
Message-Id: <20140220.133429.225365208847105257.davem@davemloft.net>
To: dhowells@redhat.com
Cc: akpm@linux-foundation.org, linux-arch@vger.kernel.org, arnd@arndb.de,
        linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [PATCH 2/4] Sparc: sparc_cpu_model isn't in asm/system.h any
 more [ver #2]
From: David Miller <davem@davemloft.net>
In-Reply-To: <17732.1392912492@warthog.procyon.org.uk>
References: <20140212154559.2405.3104.stgit@warthog.procyon.org.uk>
	<17732.1392912492@warthog.procyon.org.uk>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 20 Feb 2014 10:34:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Thu, 20 Feb 2014 16:08:12 +0000

> sparc_cpu_model isn't in asm/system.h any more, so remove a comment about it.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Applied, thanks David.
