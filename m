Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564AbaAGBAG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 20:00:06 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:36504 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756583AbaAGBAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 20:00:04 -0500
Date: Mon, 06 Jan 2014 20:00:02 -0500 (EST)
Message-Id: <20140106.200002.1747627391067832069.davem@davemloft.net>
To: bpoirier@suse.de
Cc: edumazet@google.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        therbert@google.com
Subject: Re: [PATCH] net: Do not enable tx-nocache-copy by default
From: David Miller <davem@davemloft.net>
In-Reply-To: <1389050419-9060-1-git-send-email-bpoirier@suse.de>
References: <1389041855.12212.210.camel@edumazet-glaptop2.roam.corp.google.com>
	<1389050419-9060-1-git-send-email-bpoirier@suse.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 06 Jan 2014 17:00:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Poirier <bpoirier@suse.de>
Date: Mon,  6 Jan 2014 18:20:19 -0500

> There are many cases where this feature does not improve performance or even
> reduces it. See the following discussion for example perf numbers:
> http://thread.gmane.org/gmane.linux.network/298345
> 
> CC: Tom Herbert <therbert@google.com>
> Signed-off-by: Benjamin Poirier <bpoirier@suse.de>

Please don't provide data via a URL, which is transient.

Instead, include it inline in the commit message proper.

Thanks.
