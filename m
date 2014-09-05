Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092AbaIESu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 14:50:59 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54661 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbaIESu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 14:50:57 -0400
Date: Fri, 05 Sep 2014 11:50:53 -0700 (PDT)
Message-Id: <20140905.115053.660994166240082520.davem@davemloft.net>
To: acking@vmware.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, pv-drivers@vmware.com,
        penguin-kernel@I-love.SAKURA.ne.jp, sergei.shtylyov@cogentembedded.com
Subject: Re: [PATCH] VMXNET3: Check for map error in vmxnet3_set_mc
From: David Miller <davem@davemloft.net>
In-Reply-To: <1409688824-32619-2-git-send-email-acking@vmware.com>
References: <1409688824-32619-1-git-send-email-acking@vmware.com>
	<1409688824-32619-2-git-send-email-acking@vmware.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 05 Sep 2014 11:50:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy King <acking@vmware.com>
Date: Tue,  2 Sep 2014 13:13:44 -0700

> We should check if the map of the table actually succeeds, and also free
> resources accordingly.
> 
> Version bumped to 1.2.1.0
> 
> Acked-by: Shelley Gong <shelleygong@vmware.com>
> Acked-by: Bhavesh Davda <bhavesh@vmware.com>
> Signed-off-by: Andy King <acking@vmware.com>
> Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

Applied, thanks.
