Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854Ab3LTUwf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 15:52:35 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40637 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab3LTUwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 15:52:33 -0500
Message-ID: <52B4AE0E.8070701@infradead.org>
Date: Fri, 20 Dec 2013 12:52:30 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Rasesh Mody <rmody@brocade.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: linux-next: Tree for Dec 20 (brocade/bna)
References: <20131220172503.b2b7cb92f437d974f032e1a4@canb.auug.org.au>
In-Reply-To: <20131220172503.b2b7cb92f437d974f032e1a4@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/13 22:25, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20131219:
> 


on i386:

drivers/net/ethernet/brocade/bna/bnad.c: In function 'bnad_start_xmit':
drivers/net/ethernet/brocade/bna/bnad.c:3074:26: error: 'struct bnad_tx_vector' has no member named 'dma_len'


CONFIG_NEED_DMA_MAP_STATE is not enabled.


-- 
~Randy
