Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab3DWAjP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 20:39:15 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40643 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555Ab3DWAjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 20:39:13 -0400
Date: Mon, 22 Apr 2013 20:39:12 -0400 (EDT)
Message-Id: <20130422.203912.1469412832002282235.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, martin@hundeboll.net,
        lindner_marek@yahoo.de, ordex@autistici.org
Subject: Re: linux-next: build failure after merge of the net-next tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130419132127.05ea53adec329ca794d62be7@canb.auug.org.au>
References: <20130419132127.05ea53adec329ca794d62be7@canb.auug.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Mon, 22 Apr 2013 17:39:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 19 Apr 2013 13:21:27 +1000

> After merging the net-next tree, today's linux-next build (x86_64
> allmodconfig) failed like this:

I also made sure this got fixed in the merge commit.
