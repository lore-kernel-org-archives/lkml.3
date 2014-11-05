Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbaKEUYP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 15:24:15 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:47780 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbaKEUYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 15:24:14 -0500
Date: Wed, 05 Nov 2014 15:24:10 -0500 (EST)
Message-Id: <20141105.152410.1775725940252546246.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: viro@ZenIV.linux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bcrl@kvack.org
Subject: Re: [PATCH 1/4] inet: Add skb_copy_datagram_iter
From: David Miller <davem@davemloft.net>
In-Reply-To: <E1XlZWY-0003HZ-Ef@gondolin.me.apana.org.au>
References: <20141104033818.GA11149@gondor.apana.org.au>
	<E1XlZWY-0003HZ-Ef@gondolin.me.apana.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Nov 2014 12:24:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Herbert, please provide a cover letter for this series, and the most recent
version of patch #2 gets various rejects when I try to apply it to net-next.

Thanks.
