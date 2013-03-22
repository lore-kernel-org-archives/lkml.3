Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab3CVEWE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 00:22:04 -0400
Received: from ozlabs.org ([203.10.76.45]:47590 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751679Ab3CVEWC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 00:22:02 -0400
Date: Fri, 22 Mar 2013 15:21:59 +1100
From: Michael Ellerman <michael@ellerman.id.au>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc: drop even more unused Kconfig symbols
Message-ID: <20130322042159.GC26908@concordia>
References: <1363864206.1390.117.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363864206.1390.117.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 12:10:06PM +0100, Paul Bolle wrote:
> When I submitted commit 6805ab6daa2b589fe3242d05ddc47a9dbb0c4eb1
> ("powerpc: drop unused Kconfig symbols") I apparently failed to notice
> that my patch also made PREP_RESIDUAL and PPC_A2_DD2 unused. Drop these
> now.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) Untested.
> 
> 1) I investigated these Kconfig files a bit and discovered that PPC_PREP
> is marked BROKEN since v2.6.15, see commit
> 5be396b00ca0f2f769c55cf69bbd7c77451c925e ("powerpc: Mark PREP and
> embedded as broken for now"). Though it's not my problem, this does
> suggest PReP support can be removed entirely.

It does, and the best code is deleted code.

Care to send a patch?

cheers
