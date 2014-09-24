Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbaIXTBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 15:01:34 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47775 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbaIXTBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 15:01:32 -0400
Date: Wed, 24 Sep 2014 15:01:29 -0400 (EDT)
Message-Id: <20140924.150129.1615102185939385229.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2014-09-23
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140923150002.GH23806@tuxdriver.com>
References: <20140923150002.GH23806@tuxdriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 24 Sep 2014 12:01:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 23 Sep 2014 11:00:02 -0400

> Please consider pulling this one last batch of fixes intended for the 3.17 stream!
> 
> For the NFC bits, Samuel says:
> 
> "Hopefully not too late for a handful of NFC fixes:
> 
> - 2 potential build failures for ST21NFCA and ST21NFCB, triggered by a
>   depmod dependenyc cycle.
> - One potential buffer overflow in the microread driver."
> 
> On top of that...
> 
> Emil Goode provides a fix for a brcmfmac off-by-one regression which
> was introduced in the 3.17 cycle.
> 
> Loic Poulain fixes a polarity mismatch for a variable assignment
> inside of rfkill-gpio.
> 
> Wojciech Dubowik prevents a NULL pointer dereference in ath9k.
> 
> Please let me know if there are problems!

Pulled, thanks John.
