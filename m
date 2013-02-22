Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395Ab3BVMOY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 07:14:24 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:40367 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806Ab3BVMOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 07:14:22 -0500
MIME-Version: 1.0
In-Reply-To: <20130222115021.d61d6101d1531f8dd4b581de@canb.auug.org.au>
References: <20130222115021.d61d6101d1531f8dd4b581de@canb.auug.org.au>
Date: Fri, 22 Feb 2013 14:06:22 +0200
Message-ID: <CAJZOPZLeNGwBy7YCTO1Ke7zzkGQDw8hGMGOsT7nt_QrSmX87zg@mail.gmail.com>
Subject: Re: linux-next: manual merge of the infiniband tree with Linus' tree
From: Or Gerlitz <or.gerlitz@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Roland Dreier <roland@kernel.org>, linux-rdma@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>, "David S. Miller" <davem@davemloft.net>,
        Yan Burman <yanb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2013 at 2:50 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> Today's linux-next merge of the infiniband tree got a conflict in
> drivers/infiniband/ulp/ipoib/ipoib_ethtool.c between commit 7826d43f2db4
> ("ethtool: fix drvinfo strings set in drivers") from the  tree and commit
> 4b48680b5572 ("IPoIB: Add version and firmware info to ethtool
> reporting") from the infiniband tree.
>
> I fixed it up (using the latter version as it included the change to use
> strlcpy) and can carry the fix as necessary (no action is required).

thanks for fixing thay up!

Acked-by: Or Gerlitz <ogerlitz@mellanox.com>
