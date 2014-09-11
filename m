Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbaIKHsJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 03:48:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:54472 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbaIKHsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 03:48:07 -0400
Date: Thu, 11 Sep 2014 08:48:04 +0100
From: Thomas Graf <tgraf@suug.ch>
To: NeilBrown <neilb@suse.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] rhashtable: remove duplicate comment.
Message-ID: <20140911074804.GA18084@casper.infradead.org>
References: <20140911171019.223c287f@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140911171019.223c287f@notabene.brown>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <tgraf@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/14 at 05:10pm, NeilBrown wrote:
> 
> 
> The second comment is identical to the earlier comment, just indented
> a bit. This is confusing, so remove it.
> 
> Also expand that first comment to mention the splicing that happens.
> 
> Signed-off-by: NeilBrown <neilb@suse.de>

Acked-by: Thomas Graf <tgraf@suug.ch>
