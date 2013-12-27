Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab3L0Rea (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 12:34:30 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:59759 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716Ab3L0Re3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 12:34:29 -0500
Date: Fri, 27 Dec 2013 12:34:27 -0500 (EST)
Message-Id: <20131227.123427.362811725046494702.davem@davemloft.net>
To: sasha.levin@oracle.com
Cc: venkat.x.venkatsubra@oracle.com, rds-devel@oss.oracle.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rds: prevent dereference of a NULL device
From: David Miller <davem@davemloft.net>
In-Reply-To: <1387428582-961-1-git-send-email-sasha.levin@oracle.com>
References: <1387428582-961-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 27 Dec 2013 09:34:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sasha Levin <sasha.levin@oracle.com>
Date: Wed, 18 Dec 2013 23:49:42 -0500

> Binding might result in a NULL device, which is dereferenced
> causing this BUG:
 ...
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

Applied and queued up for -stable, thanks.
