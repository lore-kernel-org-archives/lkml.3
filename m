Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab3COQr0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 12:47:26 -0400
Received: from gate.crashing.org ([63.228.1.57]:52190 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920Ab3COQrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 12:47:25 -0400
Subject: Re: [PATCH] powerpc: remove "config 8260_PCI9"
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1363274097.1335.83.camel@x61.thuisdomein>
Date: Fri, 15 Mar 2013 11:17:11 -0500
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <5EB0C1E1-F71E-4B3C-8471-BA899FEC2DFD@kernel.crashing.org>
References: <1363274097.1335.83.camel@x61.thuisdomein>
To: Paul Bolle <pebolle@tiscali.nl>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 14, 2013, at 10:14 AM, Paul Bolle wrote:

> The last user of Kconfig symbol 8260_PCI9 got removed in release v3.2.
> Remove this symbol too.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) Untested.
> 
> 1) This probably is a second order effect of my commit
> 6805ab6daa2b589fe3242d05ddc47a9dbb0c4eb1 ("powerpc: drop unused Kconfig
> symbols"). Not sure how I missed that.
> 
> arch/powerpc/Kconfig | 5 -----
> 1 file changed, 5 deletions(-)

applied to next

- k
