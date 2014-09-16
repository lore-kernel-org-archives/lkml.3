Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279AbaIPUkw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 16:40:52 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58141 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212AbaIPUku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 16:40:50 -0400
Date: Tue, 16 Sep 2014 16:40:49 -0400 (EDT)
Message-Id: <20140916.164049.1267182671029593358.davem@davemloft.net>
To: fabf@skynet.be
Cc: linux-kernel@vger.kernel.org, tgraf@suug.ch
Subject: Re: [PATCH 1/1] lib: rhashtable: remove second linux/log2.h
 inclusion
From: David Miller <davem@davemloft.net>
In-Reply-To: <1410890658-31144-1-git-send-email-fabf@skynet.be>
References: <1410890658-31144-1-git-send-email-fabf@skynet.be>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 16 Sep 2014 13:40:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>
Date: Tue, 16 Sep 2014 20:04:18 +0200

> linux/log2.h was included twice.
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

If you expect this to go into the networking tree, you'll need to
resubmit this with netdev@vger.kernel.org CC:'d.

Thank you.
