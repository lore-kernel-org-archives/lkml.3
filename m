Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbaAPTju (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 14:39:50 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:53376 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaAPTjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 14:39:48 -0500
Date: Thu, 16 Jan 2014 11:39:47 -0800 (PST)
Message-Id: <20140116.113947.1353295150580987909.davem@davemloft.net>
To: jackm@dev.mellanox.co.il
Cc: pebolle@tiscali.nl, ogerlitz@mellanox.com, ronye@mellanox.com,
        hadarh@mellanox.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] net/mlx4_core: clean up cq_res_start_move_to()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140116094639.6fe72bcf@jpm-OptiPlex-GX620>
References: <20140114084752.1db64b21@jpm-OptiPlex-GX620>
	<1389728736.28068.8.camel@x220>
	<20140116094639.6fe72bcf@jpm-OptiPlex-GX620>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Morgenstein <jackm@dev.mellanox.co.il>
Date: Thu, 16 Jan 2014 09:46:39 +0200

> ACK.  OK.

This is not the correct way to ack a patch.

First of all, you should not top post.  Instead you should quote
the relevant parts of the email you are replying to, and then add
your new content underneath.

In this circumstance, the "relevant parts" are just the commit log
message from the patch submitter.  There is no reason ever to quote
the patch itself unless you are making comments on specific parts.

And you specify your ACK using a properly formed "Acked-by: "
line.

Please look at how other reviewers ACK patches.

Thank you.
