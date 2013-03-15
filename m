Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177Ab3COLsS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 07:48:18 -0400
Received: from mail.us.es ([193.147.175.20]:33745 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753970Ab3COLsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 07:48:17 -0400
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus1 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.97.6/16853. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-99.0/7.5):. 
 Processed in 1.882605 secs); 15 Mar 2013 11:48:15 -0000
X-Envelope-From: pneira@us.es
Date: Fri, 15 Mar 2013 12:48:12 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipv4: netfilter: use PTR_RET instead of IS_ERR + PTR_ERR
Message-ID: <20130315114812.GA8344@localhost>
References: <1363111675-21457-1-git-send-email-silviupopescu1990@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363111675-21457-1-git-send-email-silviupopescu1990@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 08:07:55PM +0200, Silviu-Mihai Popescu wrote:
> This uses PTR_RET instead of IS_ERR and PTR_ERR in order to increase
> readability.

Applied, thanks.
