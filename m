Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563AbaGJXK5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 19:10:57 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45847 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbaGJXK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 19:10:56 -0400
Date: Thu, 10 Jul 2014 16:10:53 -0700 (PDT)
Message-Id: <20140710.161053.291577122645461749.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2014-07-10
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140710212248.GB21203@tuxdriver.com>
References: <20140710212248.GB21203@tuxdriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 10 Jul 2014 16:10:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 10 Jul 2014 17:22:49 -0400

> Please pull this batch of fixes intended for the 3.16 stream!
> 
> For the iwlwifi bits, Emmanuel says:
> 
> "I have here 2 patches that disable the usage of CTS to self. This
> keeps making trouble to the firmware and is not a really reliable
> protection anyway. We may re-enable it in the future, but in rarer
> cases. Along with this, I have a fix from Ilan that prevents a
> firmware assertion."
> 
> On top of that...
> 
> Amitkumar Karwar provides an mwifiex fix to properly initialize
> (i.e. zero) tx_info/rx_info.
> 
> Andrea Merello stops rt2800usb from doing DMA operations on the
> stack...yikes!
> 
> Please let me know if there are problems...

Pulled, thanks John.
