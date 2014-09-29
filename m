Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979AbaI2UIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 16:08:19 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33515 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935AbaI2UIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 16:08:16 -0400
Date: Mon, 29 Sep 2014 16:08:13 -0400 (EDT)
Message-Id: <20140929.160813.1739128124571074828.davem@davemloft.net>
To: sylvain.hitier@gmail.com
Cc: nhorman@tuxdriver.com, linux-kernel@vger.kernel.org, mroos@linux.ee
Subject: Re: [PATCH v2] 3c59x: fix bad split of
 cpu_to_le32(pci_map_single())
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140929194512.GB15737@erable>
References: <20140925151519.GA12225@erable>
	<20140929.153748.2020820992295588670.davem@davemloft.net>
	<20140929194512.GB15737@erable>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Sep 2014 13:08:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sylvain 'ythier' Hitier <sylvain.hitier@gmail.com>
Date: Mon, 29 Sep 2014 19:45:12 +0000

> When: 2014-09-29_1@15-37-48 -0400
> Who:  David Miller
> What:
>> Can someone please clean this up and submit it properly?
> 
> I'm willing to do it, but...
> could you elaborate on "clean up" and "properly"?
> 
> Would it be OK for me re-sending my part as v3 including Neil's ack?
> Or are you expecting a unique patch combining Neil's changes and mine?

You should not submit patches as a reply to a discussion, it must be
done as a fresh mailing list posting.

The posting must also be properly formed, in that "Subject: " should
be of the form "[PATCH vx] ${subsystem}: Description."  and the mail
message body must be the commit message with appropriate signoffs
and ACKs, then the patch comes next.

This is fully described, in detail, in Documentation/SubmittingPatches
