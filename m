Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab3LLUfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 15:35:54 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:39590 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab3LLUfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 15:35:47 -0500
Date: Thu, 12 Dec 2013 15:35:45 -0500 (EST)
Message-Id: <20131212.153545.1184197791301496227.davem@davemloft.net>
To: nicolas.dichtel@6wind.com
Cc: gregkh@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        williams@redhat.com, linux-rt-users@vger.kernel.org, lclaudio@uudg.org
Subject: Re: [BUG] stable v3.10.16+ introduced by "ip6tnl: allow to use
 rtnl ops on fb tunnel"
From: David Miller <davem@davemloft.net>
In-Reply-To: <52A987AD.4030204@6wind.com>
References: <20131209002531.GB14382@kroah.com>
	<20131211.165331.495095016561766264.davem@davemloft.net>
	<52A987AD.4030204@6wind.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 12 Dec 2013 12:35:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Date: Thu, 12 Dec 2013 10:53:49 +0100

> Steven, will you submit this patch properly or should I do this?

Nicolas please submit the change, thanks.
