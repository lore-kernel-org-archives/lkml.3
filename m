Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab3G2INx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 04:13:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:57040 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab3G2INv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 04:13:51 -0400
Date: Mon, 29 Jul 2013 09:13:50 +0100
From: Thomas Graf <tgraf@suug.ch>
To: David Miller <davem@davemloft.net>
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
 (netnext-tree related)
Message-ID: <20130729081350.GA28340@casper.infradead.org>
References: <20130729162544.574e4d7ffccf0f6bff5ba4c4@canb.auug.org.au>
 <20130729.004746.91827990830866654.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130729.004746.91827990830866654.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <tgraf@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/13 at 12:47am, David Miller wrote:
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 29 Jul 2013 16:25:44 +1000
> 
> > After merging the final tree, today's linux-next build (powerpc
> > allyesconfig) failed like this:
> 
> Sorry about that.
> 
> > I added this commit:
> 
> Applied, thanks Stephen.

Thanks for the fix-up Stephen, the include is needed on archs that
don't provide an optimized csum_ipv6_magic().
