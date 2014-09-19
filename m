Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038AbaISUeF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 16:34:05 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58999 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757686AbaISUeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 16:34:03 -0400
Date: Fri, 19 Sep 2014 16:33:59 -0400 (EDT)
Message-Id: <20140919.163359.1720346114199249960.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2014-09-17
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140917152300.GB13392@tuxdriver.com>
References: <20140917152300.GB13392@tuxdriver.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 19 Sep 2014 13:34:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 17 Sep 2014 11:23:01 -0400

> Please pull this batch of fixes intended for the 3.17 stream...
> 
> Arend van Spriel sends a trio of minor brcmfmac fixes, including a
> fix for a Kconfig/build issue, a fix for a crash (null reference),
> and a regression fix related to event handling on a P2P interface.
> 
> Hante Meuleman follows-up with a brcmfmac fix for a memory leak.
> 
> Johannes Stezenbach brings an ath9k_htc fix for a regression related
> to hardware decryption offload.
> 
> Marcel Holtmann delivers a one-liner to properly mark a device ID
> table in rfkill-gpio.
> 
> Please let me know if there are problems!

Pulled, thanks John.
