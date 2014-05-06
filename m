Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933927AbaEFDWe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 23:22:34 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36016 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933809AbaEFDWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 23:22:33 -0400
Date: Mon, 05 May 2014 23:22:31 -0400 (EDT)
Message-Id: <20140505.232231.1253667586982376120.davem@davemloft.net>
To: andi@firstfloor.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tom.zanussi@linux.intel.com, ak@linux.intel.com
Subject: Re: [PATCH 09/24] net, diet: Make ethtool optional
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140506031412.GN2382@two.firstfloor.org>
References: <1399328773-6531-10-git-send-email-andi@firstfloor.org>
	<20140505.231140.2172378266544060318.davem@davemloft.net>
	<20140506031412.GN2382@two.firstfloor.org>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 05 May 2014 20:22:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Tue, 6 May 2014 05:14:12 +0200

> You can configure the IP address and transmit and receive packets,
> and that is all a small embedded system is ever interested in.

Then let's agree to disagree, I am absolutely certain that small
systems are interested in much more than just these simple
configuration operations.
