Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877AbaJ0Tqs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:46:48 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50360 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbaJ0Tqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:46:46 -0400
Date: Mon, 27 Oct 2014 15:46:44 -0400 (EDT)
Message-Id: <20141027.154644.1712309471040445929.davem@davemloft.net>
To: fabf@skynet.be
Cc: linux-kernel@vger.kernel.org, acme@ghostprotocols.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/1 net-next] ipx: replace __inline__ by inline
From: David Miller <davem@davemloft.net>
In-Reply-To: <1414433352-29210-1-git-send-email-fabf@skynet.be>
References: <1414433352-29210-1-git-send-email-fabf@skynet.be>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Oct 2014 12:46:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>
Date: Mon, 27 Oct 2014 19:09:12 +0100

> Signed-off-by: Fabian Frederick <fabf@skynet.be>

If it's in a foo.c file, just kill the inline completely and let the
compiler decide.

Thanks.
