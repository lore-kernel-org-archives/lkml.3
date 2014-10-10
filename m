Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928AbaJJSuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 14:50:21 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55966 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbaJJSuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 14:50:20 -0400
Date: Fri, 10 Oct 2014 14:50:17 -0400 (EDT)
Message-Id: <20141010.145017.157815509134709496.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-next 2014-10-09
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141009154402.GB13986@tuxdriver.com>
References: <20141009154402.GB13986@tuxdriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 10 Oct 2014 11:50:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 9 Oct 2014 11:44:02 -0400

> Please pull this batch of fixes intended for the 3.18 stream!
> 
> Andrea Merello makes rtl818x_pci use a more reasonable transmission
> rate for HW generated frames.
> 
> Fabian Frederick tweaks some kernel-doc bits to avoid warnings.
> 
> Larry Finger corrects a possible unaligned access in the rtlwifi code.
> 
> Marek Puzyniak avoids a kernel panic in ath9k_hw_reset.
> 
> Sujith Manoharan goes for the hat trick -- he fixes a smatch warning
> in the shared ath code, he fixes a crash in ath9k, and he corrects
> a sequence number assignment problem in ath9k too.
> 
> For ease of merging, I pulled the last bits of the wireless tree as well...
> 
> Please let me know if there are problems!

Pulled, thank you John.
