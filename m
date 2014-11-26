Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250AbaKZKYW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 05:24:22 -0500
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:40766 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750951AbaKZKYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 05:24:12 -0500
Date: Wed, 26 Nov 2014 11:24:02 +0100
From: Florian Westphal <fw@strlen.de>
To: Andreas Ruprecht <rupran@einserver.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: netfilter: Fix undefined reference to
 nf_nat_redirect_* functions
Message-ID: <20141126102402.GA24801@breakpoint.cc>
References: <1416928034-10882-1-git-send-email-rupran@einserver.de>
 <1416994537-1592-1-git-send-email-rupran@einserver.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416994537-1592-1-git-send-email-rupran@einserver.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Ruprecht <rupran@einserver.de> wrote:
> Additionally it is necessary to provide stubs for the
> nf_nat_redirect_ipv{4,6} functions in case the header is included but
> the corresponding Kconfig feature is not enabled.

Hmmm, not following.

Can you elaborate?

Under which circumstances do we have a call to nf_nat_redirect_ipv4()
(i.e., linker error) but can safely do a noop operation instead of the
requested nat redirect...?
