Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077Ab3FZIgZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 04:36:25 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38947 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047Ab3FZIgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 04:36:21 -0400
Date: Wed, 26 Jun 2013 01:36:20 -0700 (PDT)
Message-Id: <20130626.013620.38647708061243546.davem@davemloft.net>
To: Alexey.Brodkin@synopsys.com
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
 (net-next tree related)
From: David Miller <davem@davemloft.net>
In-Reply-To: <4881796E12491D4BB15146FE0209CE643F603C48@DE02WEMBXB.internal.synopsys.com>
References: <20130626175610.8a8b6606fd9a5b6269398059@canb.auug.org.au>
	<4881796E12491D4BB15146FE0209CE643F603C48@DE02WEMBXB.internal.synopsys.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Date: Wed, 26 Jun 2013 08:07:37 +0000

> On 06/26/2013 11:56 AM, Stephen Rothwell wrote:
>> Hi all,
>>
>> After merging the final tree, today's linux-next build (powerpc
>> allyesconfig) failed like this:
> []
>> Caused by commit e4f2379db6c6 ("ethernet/arc/arc_emac - Add new driver")
>> from the net-next tree.
>>
>> I have reverted that commit for today.
> 
> I've just sent a patch that fixes reported issues (both errors and 
> warnings).

And I've just applied it.
