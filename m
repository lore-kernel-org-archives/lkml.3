Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346AbaDKUfV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 16:35:21 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:59015 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239AbaDKUfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 16:35:19 -0400
Date: Fri, 11 Apr 2014 16:35:18 -0400 (EDT)
Message-Id: <20140411.163518.681796977501065636.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2014-04-10
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140410174547.GC13595@tuxdriver.com>
References: <20140410174547.GC13595@tuxdriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=euc-kr
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 11 Apr 2014 13:35:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 10 Apr 2014 13:45:47 -0400

> Please pull this batch of fixes intended for the 3.15 stream!
> 
> Chun-Yeow Yeoh gives us an ath9k_htc fix so that mac80211 can report
> last_tx_rate correctly for those devices..
> 
> Fariya Fatima has a number of small fixes for things identified by
> the static analysis folks in the new rsi driver.
> 
> Felix Fietkau brings an ath9k fix to better support some older chips,
> and a fix for a scheduling while atomic bug introduced by an earlier
> patch.
> 
> Janusz Dziedzic produced an ath9k fix to only enable DFS when a
> related build option is selected.
> 
> Paul Bolle removes some dead code in rtlwifi.
> 
> Rafa©© Mi©©ecki fixes some b43 code that was accessing some registers
> with operations for the wrong register width.
> 
> Please let me know if there are problems!

Pulled, thanks a lot John.
