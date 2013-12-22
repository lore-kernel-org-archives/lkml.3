Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431Ab3LVW5D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 17:57:03 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:53078 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755932Ab3LVW5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 17:57:01 -0500
Date: Sun, 22 Dec 2013 17:56:59 -0500 (EST)
Message-Id: <20131222.175659.1156282573702420627.davem@davemloft.net>
To: nhorman@tuxdriver.com
Cc: linux-sctp@vger.kernel.org, vyasevich@gmail.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] sctp: Consolidate and ratelimit deprecation
 warnings
From: David Miller <davem@davemloft.net>
In-Reply-To: <1387297199-14363-1-git-send-email-nhorman@tuxdriver.com>
References: <1387205049-22752-1-git-send-email-nhorman@tuxdriver.com>
	<1387297199-14363-1-git-send-email-nhorman@tuxdriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Sun, 22 Dec 2013 14:57:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 17 Dec 2013 11:19:57 -0500

> The SCTP protocol has several deprecation warnings in its setsockopt path that
> can be triggered by unprivlidged users.  Since these are not ratelimited, we can
> spam the logs quite easily here.  Since these are all deprecation warnings, and
> that type of warning isn't uncommon in the rest of the kernel, lets make a
> common pr_warn_deprecated macro to produce somewhat generalized ratelimited
> deprecation warnings easily
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>

Neil, I really wish you would CC: netdev on all of the patches in the
series.  Otherwise only some of them end up in patchwork, and this makes
a lot more work for me if I want to actually apply this, which I do.

Please resubmit this properly, thanks.
