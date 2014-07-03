Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725AbaGCAGF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 20:06:05 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42223 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaGCAGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 20:06:03 -0400
Date: Wed, 02 Jul 2014 17:06:02 -0700 (PDT)
Message-Id: <20140702.170602.1488348350960881393.davem@davemloft.net>
To: fabf@skynet.be
Cc: linux-kernel@vger.kernel.org, dmitry.tarnyagin@lockless.no,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] net/caif/caif_socket.c: remove unnecessary null
 test before debugfs_remove_recursive
From: David Miller <davem@davemloft.net>
In-Reply-To: <1403903263-13355-1-git-send-email-fabf@skynet.be>
References: <1403903263-13355-1-git-send-email-fabf@skynet.be>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 02 Jul 2014 17:06:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>
Date: Fri, 27 Jun 2014 23:07:43 +0200

> based on checkpatch:
> "debugfs_remove_recursive(NULL) is safe this check is probably not required"
> 
> Cc: Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Also applied to net-next, thanks.
