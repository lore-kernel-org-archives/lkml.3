Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab3IXSGs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 14:06:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732Ab3IXSGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 14:06:47 -0400
Date: Tue, 24 Sep 2013 14:06:44 -0400 (EDT)
Message-Id: <20130924.140644.252362547499379161.davem@redhat.com>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/10] amd/7990: Remove extern from function prototypes
From: David Miller <davem@redhat.com>
In-Reply-To: <1380041755.3575.93.camel@joe-AO722>
References: <5570169a078375fa8662adeb2a7f24c1ae718bfb.1379974101.git.joe@perches.com>
	<65ef2eba58fddc268ba0afb4de7757f073d3bb49.1379974101.git.joe@perches.com>
	<1380041755.3575.93.camel@joe-AO722>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Tue, 24 Sep 2013 09:55:55 -0700

> Hey David.
> 
> This ended up in your tree as
> commit 44da5c2f523876a02336c18dbcce93449fdbf0ca
> without your signoff.
> 
> Is there something I need to do differently so
> your scripts add your sign-off properly or did
> this manage to just slip through via some manual
> git am without the -s?

I forgot to "--signoff", that's all.
