Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827AbaKEV50 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 16:57:26 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:48584 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbaKEV5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 16:57:23 -0500
Date: Wed, 05 Nov 2014 16:57:19 -0500 (EST)
Message-Id: <20141105.165719.835728206041332333.davem@davemloft.net>
To: viro@ZenIV.linux.org.uk
Cc: herbert@gondor.apana.org.au, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bcrl@kvack.org
Subject: Re: [PATCH 1/4] inet: Add skb_copy_datagram_iter
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141105210745.GT7996@ZenIV.linux.org.uk>
References: <20141105035536.GO7996@ZenIV.linux.org.uk>
	<20141105.155054.2198151263164321219.davem@davemloft.net>
	<20141105210745.GT7996@ZenIV.linux.org.uk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Nov 2014 13:57:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ZenIV.linux.org.uk>
Date: Wed, 5 Nov 2014 21:07:45 +0000

> Ping me when you put it there, OK?  I'll rebase the rest of old stuff on
> top of it (similar helpers, mostly).

I just pushed it into net-next, thanks Al.
