Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab3J1E04 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 00:26:56 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56244 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab3J1E0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 00:26:55 -0400
Date: Mon, 28 Oct 2013 00:26:54 -0400 (EDT)
Message-Id: <20131028.002654.404759341390215962.davem@davemloft.net>
To: ben@decadent.org.uk
Cc: venkat.x.venkatsubra@oracle.com, linux-kernel@vger.kernel.org,
        rds-devel@oss.oracle.com, netdev@vger.kernel.org
Subject: Re: [PATCH 7/8] rds: Pass pointers to virt_to_page(), not integers
From: David Miller <davem@davemloft.net>
In-Reply-To: <1382910856.2994.51.camel@deadeye.wl.decadent.org.uk>
References: <1382910437.2994.43.camel@deadeye.wl.decadent.org.uk>
	<1382910856.2994.51.camel@deadeye.wl.decadent.org.uk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Sun, 27 Oct 2013 21:26:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>
Date: Sun, 27 Oct 2013 21:54:16 +0000

> Most architectures define virt_to_page() as a macro that casts its
> argument such that an argument of type unsigned long will be accepted
> without complaint.  However, the proper type is void *, and passing
> unsigned long results in a warning on MIPS.
> 
> Compile-tested only.
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

This looks fine:

Acked-by: David S. Miller <davem@davemloft.net>
