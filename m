Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbaLOQor (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 11:44:47 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:43619 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbaLOQon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 11:44:43 -0500
Date: Mon, 15 Dec 2014 11:44:40 -0500 (EST)
Message-Id: <20141215.114440.1645405042049378253.davem@davemloft.net>
To: asaf.vertz@tandemg.com
Cc: ebiederm@xmission.com, julia.lawall@lip6.fr, himangi774@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cirrus: cs89x0: fix time comparison
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141214083418.GA25910@ubuntu>
References: <20141214083418.GA25910@ubuntu>
X-Mailer: Mew version 6.6 on Emacs 24.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 15 Dec 2014 08:44:42 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Asaf Vertz <asaf.vertz@tandemg.com>
Date: Sun, 14 Dec 2014 10:34:18 +0200

> To be future-proof and for better readability the time comparisons are
> modified to use time_before, time_after, and time_after_eq instead of
> plain, error-prone math.
> 
> Signed-off-by: Asaf Vertz <asaf.vertz@tandemg.com>

Applied.
