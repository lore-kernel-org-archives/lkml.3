Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935068Ab3E2G4b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 02:56:31 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58926 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933908Ab3E2G43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 02:56:29 -0400
Date: Tue, 28 May 2013 23:56:28 -0700 (PDT)
Message-Id: <20130528.235628.1501314742626907861.davem@davemloft.net>
To: mingo@kernel.org
Cc: luto@amacapital.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, trinity@vger.kernel.org
Subject: Re: [PATCH/FIX] net: Block MSG_CMSG_COMPAT in send(m)msg and
 recv(m)msg
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130528085600.GD30172@gmail.com>
References: <cover.1369177867.git.luto@amacapital.net>
	<aa015609319786835bcab445d507faa75c11f111.1369177867.git.luto@amacapital.net>
	<20130528085600.GD30172@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>
Date: Tue, 28 May 2013 10:56:00 +0200

> MSG_CMSG_COMPAT is (AFAIK) not intended to be part of the API --
> it's a hack that steals a bit to indicate to other networking code
> that a compat entry was used.  So don't allow it from a non-compat
> syscall.
> 
> This prevents an oops when running this code:
 ...
> Cc: David S. Miller <davem@davemloft.net>
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>

Applied and queued up for -stable.
