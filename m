Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758825Ab3EWTXG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 15:23:06 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33566 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757946Ab3EWTXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 15:23:04 -0400
Date: Thu, 23 May 2013 12:23:03 -0700 (PDT)
Message-Id: <20130523.122303.1335553698804467865.davem@davemloft.net>
To: michel@digirati.com.br
Cc: netdev@vger.kernel.org, edumazet@google.com, pshelar@nicira.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] net-next: export skb_splice_bits()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1369328974.3123.77.camel@Thor>
References: <1369328974.3123.77.camel@Thor>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ummm, no.

You don't export every single function just because it appears in a header
file.

When we have an in-kernel module that needs these functions, we can
export them, but no sooner.

So until you submit a set of changes that use these routines from modules
we're not exporting them.
