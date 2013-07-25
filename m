Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab3GYIf5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 04:35:57 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40452 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662Ab3GYIfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 04:35:54 -0400
Date: Thu, 25 Jul 2013 01:35:50 -0700 (PDT)
Message-Id: <20130725.013550.930278380548483073.davem@davemloft.net>
To: andi@etezian.org
Cc: dominique.martinet@cea.fr, pebolle@tiscali.nl, lucho@ionkov.net,
        ericvh@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net, rminnich@sandia.gov
Subject: Re: [V9fs-developer] [PATCH] net: trans_rdma: remove unused
 function
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130725082741.GB4295@jack.whiskey>
References: <20130725061411.GA8579@nautica>
	<20130725064802.GA12569@nautica>
	<20130725082741.GB4295@jack.whiskey>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 25 Jul 2013 01:35:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Shyti <andi@etezian.org>
Date: Thu, 25 Jul 2013 10:27:41 +0200

> I would prefer to NACK my patch, it messes up things more than
> fixes.

Your patch it already applied to my tree, so you must send me
something which fixes things.

> If we really want to get rid of this function we should
> completely revert this patch:
> 
> 80b45261a0b263536b043c5ccfc4ba4fc27c2acc

Such as this.
