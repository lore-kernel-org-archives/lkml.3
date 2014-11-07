Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490AbaKGDQB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 22:16:01 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:33514 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbaKGDQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 22:16:00 -0500
Date: Thu, 06 Nov 2014 22:15:57 -0500 (EST)
Message-Id: <20141106.221557.165590048048299292.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2014-11-06
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141106205231.GE4440@tuxdriver.com>
References: <20141106205231.GE4440@tuxdriver.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Nov 2014 19:16:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 6 Nov 2014 15:52:31 -0500

> Please pull this batch of fixes intended for the 3.18 stream...
> 
> For the mac80211 bits, Johannes says:
> 
> "This contains another small set of fixes for 3.18, these are all
> over the place and most of the bugs are old, one even dates back
> to the original mac80211 we merged into the kernel."
> 
> For the iwlwifi bits, Emmanuel says:
> 
> "I fix here two issues that are related to the firmware
> loading flow. A user reported that he couldn't load the
> driver because the rfkill line was pulled up while we
> were running the calibrations. This was happening while
> booting the system: systemd was restoring the "disable
> wifi settings" and that raised an RFKILL interrupt during
> the calibration. Our driver didn't handle that properly
> and this is now fixed."
> 
> Please let me know if there are problems!

Pulled, thanks John.
