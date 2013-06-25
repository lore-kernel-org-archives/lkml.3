Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012Ab3FYXFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 19:05:31 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:34726 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab3FYXF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 19:05:29 -0400
Date: Tue, 25 Jun 2013 16:05:27 -0700 (PDT)
Message-Id: <20130625.160527.623885667817641809.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2013-06-25
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130625174507.GB31220@tuxdriver.com>
References: <20130625174507.GB31220@tuxdriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 25 Jun 2013 13:45:07 -0400

> A few more late-breaking fixes hoping for 3.10...
> 
> Regarding the Bluetooth fix, Gustavo says:
> 
> "A important fix to 3.10, this patch fixes an issues that was preventing
> the l2cap info response command to be handled properly."
> 
> Also for that Bluetooth fix, Johan adds:
> 
> "Once the code gives up parsing this PDU it also gives up essential
> parts of the L2CAP connection creation process, i.e. without this
> patch the stack will fail to establish connections properly."
> 
> Moving onto ath9k, Felix Fietkau fixes an RCU locking issue in
> the transmit path.  As for ath9k_htc, Sujith Manoharan fixes some
> authentication timeouts by ensuring that a chip reset is done when
> IDLE is turned off.
> 
> I think these are all micro-fixes that shouldn't cause any trouble.
> Please let me know if there are problems!

Pulled, thanks John.
