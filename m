Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455AbaGCAF4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 20:05:56 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42219 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaGCAFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 20:05:55 -0400
Date: Wed, 02 Jul 2014 17:05:54 -0700 (PDT)
Message-Id: <20140702.170554.1567814087607685055.davem@davemloft.net>
To: fabf@skynet.be
Cc: linux-kernel@vger.kernel.org, hariprasad@chelsio.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c:
 remove unnecessary null test before debugfs_remove_recursive
From: David Miller <davem@davemloft.net>
In-Reply-To: <1403902312-10930-1-git-send-email-fabf@skynet.be>
References: <1403902312-10930-1-git-send-email-fabf@skynet.be>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 02 Jul 2014 17:05:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>
Date: Fri, 27 Jun 2014 22:51:52 +0200

> Fix checkpatch warning:
> "WARNING: debugfs_remove_recursive(NULL) is safe this check is probably not required"
> 
> Cc: Hariprasad S <hariprasad@chelsio.com>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Applied to net-next.
