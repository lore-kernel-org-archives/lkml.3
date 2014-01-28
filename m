Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639AbaA1Anq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 19:43:46 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38575 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310AbaA1Ano (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 19:43:44 -0500
Date: Mon, 27 Jan 2014 16:43:42 -0800 (PST)
Message-Id: <20140127.164342.1026192370176923084.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: gustavo@padovan.org, netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, dborkman@redhat.com,
        jukka.rissanen@linux.intel.com
Subject: Re: linux-next: manual merge of the bluetooth tree with the
 net/net-next trees
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140128095415.8382335c33545ad14d4be067@canb.auug.org.au>
References: <20140107125418.986ae20298ddc55e5e657447@canb.auug.org.au>
	<20140128095415.8382335c33545ad14d4be067@canb.auug.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 28 Jan 2014 09:54:15 +1100

> On Tue, 7 Jan 2014 12:54:18 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
 ...
>> From: Stephen Rothwell <sfr@canb.auug.org.au>
>> Date: Tue, 7 Jan 2014 12:52:43 +1100
>> Subject: [PATCH] net: 6lowpan: fixup for code movement
>> 
>> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
 ...
> I think this fix patch got missed when bluetooth was merged ... so it
> should probably go into the net tree.

Good catch, applied, thanks Stephen!
