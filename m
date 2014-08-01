Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259AbaHAIvF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 04:51:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:51280 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbaHAIvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 04:51:01 -0400
Date: Fri, 1 Aug 2014 09:50:56 +0100
From: Thomas Graf <tgraf@suug.ch>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kaber@trash.net,
        paulmck@linux.vnet.ibm.com, josh@joshtriplett.org,
        challa@noironetworks.com, walpole@cs.pdx.edu, dev@openvswitch.org,
        tklauser@distanz.ch, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 0/3 net-next] Lockless netlink_lookup() with new
 concurrent hash table
Message-ID: <20140801085056.GD16321@casper.infradead.org>
References: <cover.1406846586.git.tgraf@suug.ch>
 <20140731.223946.2222491319947824077.davem@davemloft.net>
 <20140731.224659.1839149761075616147.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140731.224659.1839149761075616147.davem@davemloft.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <tgraf@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/14 at 10:46pm, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Thu, 31 Jul 2014 22:39:46 -0700 (PDT)
> 
> > Looks great, series applied, thanks!
> 
> Actually, this needs more work, reverted:
> 
> net/netfilter/nft_hash.c: In function ‘nft_hash_destroy’:
> net/netfilter/nft_hash.c:183:3: error: ‘ht’ undeclared (first use in this function)
> net/netfilter/nft_hash.c:183:3: note: each undeclared identifier is reported only once for each function it appears in

Sorry about that. Resending.
