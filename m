Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbaIPNWj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 09:22:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:53284 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbaIPNWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 09:22:36 -0400
Date: Tue, 16 Sep 2014 14:22:30 +0100
From: Thomas Graf <tgraf@suug.ch>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: davem@davemloft.net, paulmck@linux.vnet.ibm.com,
        john.r.fastabend@intel.com, kaber@trash.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] rhashtable: Per bucket locks & expansion/shrinking
 in work queue
Message-ID: <20140916132230.GA3831@casper.infradead.org>
References: <cover.1410782841.git.tgraf@suug.ch>
 <fe862eb8add076215918a0def9c3bd4fe8a104c7.1410782841.git.tgraf@suug.ch>
 <1410794580.7106.168.camel@edumazet-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410794580.7106.168.camel@edumazet-glaptop2.roam.corp.google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <tgraf@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/14 at 08:23am, Eric Dumazet wrote:
> You need to roundup to next power of two.

Fixed, thanks!
