Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933411Ab3CTTVm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 15:21:42 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60783 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756178Ab3CTTVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 15:21:41 -0400
Date: Wed, 20 Mar 2013 15:21:38 -0400 (EDT)
Message-Id: <20130320.152138.409022277193754258.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2013-03-20
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130320191107.GA9978@tuxdriver.com>
References: <20130320191107.GA9978@tuxdriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Wed, 20 Mar 2013 12:21:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 20 Mar 2013 15:11:08 -0400

> I present to you another batch of fixes intended for the 3.9 stream...
> 
> On the bluetooth bits, Gustavo says:
> 
> "I put together 3 fixes intended for 3.9, there are support for two
> new devices and a NULL dereference fix in the SCO code."
> 
> Amitkumar Karwar fixes a command queueing race in mwifiex.
> 
> Bing Zhao provides a pair of mwifiex related to cleaning-up before
> a shutdown.
> 
> Felix Fietkau provides an ath9k fix for a regression caused by an
> earlier calibration fix, and another ath9k fix to avoid race conditions
> that unnecessarily lead to chip resets.
> 
> Jussi Kivilinna prevents and skbuff leak in rtlwifi.
> 
> Stanislaw Gruszka corrects a length paramater for a DMA buffer mapping
> operation in iwlegacy.

Pulled, thanks John!
