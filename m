Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440AbaHKQlE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 12:41:04 -0400
Received: from mail.us.es ([193.147.175.20]:37271 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123AbaHKQlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 12:41:00 -0400
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus4 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.98.4/19276. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-102.8/7.5):. 
 Processed in 2.387307 secs); 11 Aug 2014 16:40:56 -0000
X-Spam-ASN: AS42863 83.223.224.0/19
X-Envelope-From: pneira@us.es
Date: Mon, 11 Aug 2014 18:41:14 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] netfilter: nf_tables: fix error return code
Message-ID: <20140811164114.GA7770@salvia>
References: <1407415749-19978-1-git-send-email-Julia.Lawall@lip6.fr>
 <1407415749-19978-5-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407415749-19978-5-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2014 at 02:49:08PM +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Convert a zero return value on error to a negative one, as returned
> elsewhere in the function.

Applied, thanks Julia.

