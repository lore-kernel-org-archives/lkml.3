Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670AbaAJSVz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 13:21:55 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:41516 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbaAJSVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 13:21:51 -0500
Date: Fri, 10 Jan 2014 13:21:48 -0500 (EST)
Message-Id: <20140110.132148.1970065851413556681.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2014-01-09
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140109153317.GA2131@tuxdriver.com>
References: <20140109153317.GA2131@tuxdriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 9 Jan 2014 10:33:17 -0500

> I know that this is late in the process.  But, Linus did say he was
> doing an -rc8 no matter what!
> 
> For the mac80211 bits, Johannes says:
> 
> "I have a fix from Javier for mac80211_hwsim when used with wmediumd
> userspace, and a fix from Felix for buffering in AP mode."
> 
> For the NFC bits, Samuel says:
> 
> "This pull request only contains one fix for a regression introduced with
> commit e29a9e2ae165620d. Without this fix, we can not establish a p2p link
> in target mode. Only initiator mode works."
> 
> For the iwlwifi bits, Emmanuel says:
> 
> "It only includes new device IDs so it's not vital. If you have a pull
> request to net.git anyway, I'd happy to have this in."
> 
> Please let me know if there are problems!  If you don't want to pull
> this one for 3.13 then I'll just roll it into the wireless-next tree...

Pulled, thanks John.
