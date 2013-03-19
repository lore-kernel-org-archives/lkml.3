Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934479Ab3CSWx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 18:53:27 -0400
Received: from mail.us.es ([193.147.175.20]:34809 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757495Ab3CSWxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 18:53:23 -0400
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus3 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.97.6/16875. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-97.8/7.5):. 
 Processed in 1.738371 secs); 19 Mar 2013 22:53:22 -0000
X-Envelope-From: pneira@us.es
Date: Tue, 19 Mar 2013 23:53:19 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devel@openvz.org,
        Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] netfilter: nf_conntrack: Batch cleanup
Message-ID: <20130319225319.GA3669@localhost>
References: <1363254014-10725-1-git-send-email-vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363254014-10725-1-git-send-email-vdavydov@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 01:40:14PM +0400, Vladimir Davydov wrote:
> The patch introduces nf_conntrack_cleanup_net_list(), which cleanups
> nf_conntrack for a list of netns and calls synchronize_net() only once
> for them all. This should reduce netns destruction time.

Applied, thanks.
