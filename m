Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226Ab3JHTcs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 15:32:48 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54035 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628Ab3JHTcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 15:32:45 -0400
Date: Tue, 08 Oct 2013 15:32:43 -0400 (EDT)
Message-Id: <20131008.153243.1255629541932988146.davem@davemloft.net>
To: alan@signal11.us
Cc: alex.bluesman.smirnov@gmail.com, dbaryshkov@gmail.com, david@hauweele.net,
        linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 0/3] Fix race conditions in mrf24j40 interrupts
From: David Miller <davem@davemloft.net>
In-Reply-To: <1381031544-2960-1-git-send-email-alan@signal11.us>
References: <1369188080-8904-1-git-send-email-alan@signal11.us>
	<1381031544-2960-1-git-send-email-alan@signal11.us>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 08 Oct 2013 12:32:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Ott <alan@signal11.us>
Date: Sat,  5 Oct 2013 23:52:21 -0400

> After testing with the betas of this patchset, it's been rebased and is
> ready for inclusion.
> 
> David Hauweele noticed that the mrf24j40 would hang arbitrarily after some
> period of heavy traffic.  Two race conditions were discovered, and the
> driver was changed to use threaded interrupts, since the enable/disable of
> interrupts in the driver has recently been a lighning rod whenever issues
> arise related to interrupts (costing engineering time), and since threaded
> interrupts are the right way to do it.

Series applied, thanks.
