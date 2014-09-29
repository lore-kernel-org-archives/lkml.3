Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbaI2Thw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 15:37:52 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:32951 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbaI2Thu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 15:37:50 -0400
Date: Mon, 29 Sep 2014 15:37:48 -0400 (EDT)
Message-Id: <20140929.153748.2020820992295588670.davem@davemloft.net>
To: sylvain.hitier@gmail.com
Cc: nhorman@tuxdriver.com, linux-kernel@vger.kernel.org, mroos@linux.ee
Subject: Re: [PATCH v2] 3c59x: fix bad split of
 cpu_to_le32(pci_map_single())
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140925151519.GA12225@erable>
References: <20140924093021.GA7929@erable>
	<20140924101647.GA4651@hmsreliant.think-freely.org>
	<20140925151519.GA12225@erable>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Sep 2014 12:37:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Can someone please clean this up and submit it properly?

Thank you.
