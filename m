Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965405Ab3GCTRQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:17:16 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36746 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965289Ab3GCTRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:17:12 -0400
Date: Wed, 03 Jul 2013 12:17:06 -0700 (PDT)
Message-Id: <20130703.121706.662355100668505222.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, eliezer.tamir@linux.intel.com
Subject: Re: linux-next: build failure after merge of the final tree
 (net-next tree related)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130703174822.d06500db5cbd5191c39e3f08@canb.auug.org.au>
References: <20130703174822.d06500db5cbd5191c39e3f08@canb.auug.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 3 Jul 2013 17:48:22 +1000

> I cherry-picked the commit 419076f59fc5 ("net: lls fix build with
> allnoconfig") out of tomorrow's net-next tree.  (I am feeling generous
> and noticed that patch being applied :-))

Thank you :)
