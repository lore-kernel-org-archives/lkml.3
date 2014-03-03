Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbaCCUjs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 15:39:48 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:54868 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483AbaCCUjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 15:39:47 -0500
Date: Mon, 03 Mar 2014 15:39:45 -0500 (EST)
Message-Id: <20140303.153945.218115412923126825.davem@davemloft.net>
To: khoroshilov@ispras.ru
Cc: zbr@ioremap.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] connector: remove duplicated code in cn_call_callback()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1393704056-13943-1-git-send-email-khoroshilov@ispras.ru>
References: <1393704056-13943-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Mar 2014 12:39:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Khoroshilov <khoroshilov@ispras.ru>
Date: Sun,  2 Mar 2014 00:00:56 +0400

> There were a couple of patches fixing the same bug that
> results in duplicated err = 0; assignment.
> The patch removes one of them.
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Applied to net-next, thank you.
