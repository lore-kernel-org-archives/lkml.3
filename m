Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab3AOTS4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 14:18:56 -0500
Received: from mail.us.es ([193.147.175.20]:43681 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720Ab3AOTSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 14:18:54 -0500
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus2 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.97.6/16496. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-99.2/7.5):. 
 Processed in 1.915988 secs); 15 Jan 2013 19:18:51 -0000
X-Envelope-From: pneira@us.es
Date: Tue, 15 Jan 2013 20:18:49 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Cong Ding <dinggnu@gmail.com>
Cc: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: netfilter/xt_CT.c: fix uninitialized variable
Message-ID: <20130115191849.GA17140@1984>
References: <1358276314-9536-1-git-send-email-dinggnu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358276314-9536-1-git-send-email-dinggnu@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cong,

On Tue, Jan 15, 2013 at 07:58:34PM +0100, Cong Ding wrote:
> If CONFIG_NF_CONNTRACK_ZONES is not defined, the variable ret might be
> uninitialized when it goes to err1 through line 125 and 263 respectively.
> So I change these goto err1 to return -EINVAL directly.

This is already fixed in the net tree.

http://git.kernel.org/?p=linux/kernel/git/davem/net.git;a=commit;h=4610476d89d53714ca94aae081fa035908bc137a
