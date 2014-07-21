Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761AbaGUE0P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 00:26:15 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53189 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbaGUE0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 00:26:13 -0400
Date: Sun, 20 Jul 2014 21:26:12 -0700 (PDT)
Message-Id: <20140720.212612.2283654770798733694.davem@davemloft.net>
To: andrey.krieger.utkin@gmail.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org, dcb314@hotmail.com, nwf@cs.jhu.edu,
        dhowells@redhat.com
Subject: Re: [PATCH 2/5] net/rxrpc/ar-key.c: drop negativity check on
 unsigned value
From: David Miller <davem@davemloft.net>
In-Reply-To: <1405697517-23673-1-git-send-email-andrey.krieger.utkin@gmail.com>
References: <1405697517-23673-1-git-send-email-andrey.krieger.utkin@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 20 Jul 2014 21:26:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
Date: Fri, 18 Jul 2014 18:31:57 +0300

> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=80611
> Reported-by: David Binderman <dcb314@hotmail.com>
> Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>

Applied to net-next, thanks.
