Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab3J0SH4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 14:07:56 -0400
Received: from smtp0.kfki.hu ([148.6.0.25]:36315 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753064Ab3J0SHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 14:07:54 -0400
Date: Sun, 27 Oct 2013 19:07:52 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
cc: Pablo Neira Ayuso <pablo@netfilter.org>, Patrick McHardy <kaber@trash.net>,
        David Miller <davem@davemloft.net>, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: ipset: remove duplicate define
In-Reply-To: <1382524574-3214-1-git-send-email-michael.opdenacker@free-electrons.com>
Message-ID: <alpine.DEB.2.10.1310271907130.6494@blackhole.kfki.hu>
References: <1382524574-3214-1-git-send-email-michael.opdenacker@free-electrons.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Oct 2013, Michael Opdenacker wrote:

> This patch removes a duplicate define from
> net/netfilter/ipset/ip_set_hash_gen.h
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

Patch is applied to the ipset git tree, thanks.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
