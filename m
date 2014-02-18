Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbaBRV6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 16:58:32 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:36288 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbaBRV6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 16:58:31 -0500
Date: Tue, 18 Feb 2014 16:58:28 -0500 (EST)
Message-Id: <20140218.165828.242891846729845555.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2014-02-17
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140217223921.GA29923@tuxdriver.com>
References: <20140217223921.GA29923@tuxdriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Feb 2014 13:58:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 17 Feb 2014 17:39:21 -0500

> Please pull this batch of fixes intended for the 3.14 stream...
> 
> For the iwlwifi one, Emmanuel says:
> 
> "As explicitly written in the commit message, we prefer to disable Tx
> AMPDU on NICs supported by iwldvm. This feature gives a big boost in
> Tx performance, but the firmware is buggy and we can't rely on it.
> Our hope is that most of the users out there want wifi to surf on
> the web which means that they care more for Rx traffic than for Tx.
> People who want to enable it can do so with the help of a module
> parameter."
> 
> On top of that...
> 
> Dan Carpenter fixes a typo/thinko in ath5k.
> 
> Olivier Langlois fixes a couple of rtlwifi issues, one which leaves
> IRQs disabled too long (causing a variety of problems elsewhere),
> and one which fixes an incorrect return code when failing to enable
> the NIC.
> 
> Russell King fixes a NULL pointer dereference in hostap.
> 
> Stanislaw Gruszka fixes a DMA coherence issue in the rtl8187 driver.
> 
> Please let me know if there are problems!

Pulled, thanks a lot John.
