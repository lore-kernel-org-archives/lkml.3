Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844AbaIGXLf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 19:11:35 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56493 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329AbaIGXLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 19:11:33 -0400
Date: Sun, 07 Sep 2014 16:11:33 -0700 (PDT)
Message-Id: <20140907.161133.1026363467035732296.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2014-09-05
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140905150453.GB3454@tuxdriver.com>
References: <20140905150453.GB3454@tuxdriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 07 Sep 2014 16:11:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 5 Sep 2014 11:04:53 -0400

> Please pull this batch of fixes intended for the 3.17 stream...
> 
> For the mac80211 bits, Johannes says:
> 
> "Here are a few fixes for mac80211. One has been discussed for a while
> and adds a terminating NUL-byte to the alpha2 sent to userspace, which
> shouldn't be necessary but since many places treat it as a string we
> couldn't move to just sending two bytes.
> 
> In addition to that, we have two VLAN fixes from Felix, a mesh fix, a
> fix for the recently introduced RX aggregation offload, a revert for
> a broken patch (that luckily didn't really cause any harm) and a small
> fix for alignment in debugfs."
> 
> For the iwlwifi bits, Emmanuel says:
> 
> "I revert a patch that disabled CTS to self in dvm because users
> reported issues. The revert is CCed to stable since the offending
> patch was sent to stable too. I also bump the firmware API versions
> since a new firmware is coming up. On top of that, Marcel fixes a
> bug I introduced while fixing a bug in our Kconfig file."
> 
> Please let me know if there are problems!

Pulled, thanks John.
