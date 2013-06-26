Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab3FZIIj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 04:08:39 -0400
Received: from kiruna.synopsys.com ([198.182.44.80]:46160 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab3FZIHm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 04:07:42 -0400
From: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Subject: Re: linux-next: build failure after merge of the final tree
 (net-next tree related)
Thread-Topic: linux-next: build failure after merge of the final tree
 (net-next tree related)
Thread-Index: AQHOckKpyd8VKSYtlUK+St6WnEmrHw==
Date: Wed, 26 Jun 2013 08:07:37 +0000
Message-ID: <4881796E12491D4BB15146FE0209CE643F603C48@DE02WEMBXB.internal.synopsys.com>
References: <20130626175610.8a8b6606fd9a5b6269398059@canb.auug.org.au>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.121.8.30]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2013 11:56 AM, Stephen Rothwell wrote:
> Hi all,
>
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
[]
> Caused by commit e4f2379db6c6 ("ethernet/arc/arc_emac - Add new driver")
> from the net-next tree.
>
> I have reverted that commit for today.

I've just sent a patch that fixes reported issues (both errors and 
warnings).
===
[PATCH] arc_emac: fix compile-time errors & warnings on PPC64
===
So it could be merged with initial patch.

Or I may send another cumulative re-spin.

What's the best way?

Regards,
Alexey
