Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705AbaG3I0Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 04:26:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60813 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbaG3I0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 04:26:23 -0400
Message-ID: <1406708780.5347.9.camel@linux-fkkt.site>
Subject: Re: linux-next: build failure after merge of the net tree
From: Oliver Neukum <oneukum@suse.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 30 Jul 2014 10:26:20 +0200
In-Reply-To: <20140730103617.1a9690de@canb.auug.org.au>
References: <20140730103617.1a9690de@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-30 at 10:36 +1000, Stephen Rothwell wrote:

> Caused by commit 20fbe3ae990f ("cdc_subset: deal with a device that
> needs reset for timeout").
> 
> I have used the net tree from next-20140729 for today (i.e. up to
> commit fe26566d8a0515 ("bnx2x: fix crash during TSO tunneling")).

Thank you. Patch is on the way.

	Regards
		Oliver


