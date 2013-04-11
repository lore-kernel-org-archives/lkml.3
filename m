Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965041Ab3DKAyH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 20:54:07 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54851 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935367Ab3DKAyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 20:54:05 -0400
Date: Wed, 10 Apr 2013 20:54:01 -0400 (EDT)
Message-Id: <20130410.205401.1135160208998128324.davem@davemloft.net>
To: jhbird.choi@samsung.com
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, vyasevic@redhat.com
Subject: Re: [PATCH 3.8-stable] net: count hw_addr syncs so that unsync
 works properly.
From: David Miller <davem@davemloft.net>
In-Reply-To: <000001ce364b$f1b178b0$d5146a10$%choi@samsung.com>
References: <000001ce364b$f1b178b0$d5146a10$%choi@samsung.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Wed, 10 Apr 2013 17:54:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonghwan Choi <jhbird.choi@samsung.com>
Date: Thu, 11 Apr 2013 09:31:44 +0900

> This patch looks like it should be in the 3.8-stable tree, should we apply
> it?

I queue up networking patches as needed and that queue is
visible at:

http://patchwork.ozlabs.org/user/bundle/2566/?state=*

and yes this patch, along with many others, are there.

I submit networking patches to -stable at a time of my
own choosing, in an effort to allow bug fixes to cook
in Linus's tree for some time just in case the fixes
themselves have bugs.
