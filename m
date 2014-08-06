Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbaHFVmk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 17:42:40 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44019 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000AbaHFVmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 17:42:39 -0400
Date: Wed, 06 Aug 2014 14:42:38 -0700 (PDT)
Message-Id: <20140806.144238.2222819388942393951.davem@davemloft.net>
To: hans@hanshq.net
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/15] sparc: fix decimal printf format specifiers
 prefixed with 0x
From: David Miller <davem@davemloft.net>
In-Reply-To: <1407300096-32151-1-git-send-email-hans@hanshq.net>
References: <1407300096-32151-1-git-send-email-hans@hanshq.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 Aug 2014 14:42:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans Wennborg <hans@hanshq.net>
Date: Tue,  5 Aug 2014 21:41:36 -0700

> The prefix suggests the number should be printed in hex, so use
> the %x specifier to do that.
> 
> Found by using regex suggested by Joe Perches.
> 
> Signed-off-by: Hans Wennborg <hans@hanshq.net>

Applied, thank you.
