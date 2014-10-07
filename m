Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbaJGVDh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 17:03:37 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:48630 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755256AbaJGVDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 17:03:36 -0400
Date: Tue, 07 Oct 2014 17:03:34 -0400 (EDT)
Message-Id: <20141007.170334.1642010479995041045.davem@davemloft.net>
To: fabf@skynet.be
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH V2 net-next] af_unix: remove 0 assignment on static
From: David Miller <davem@davemloft.net>
In-Reply-To: <1412715735-6757-1-git-send-email-fabf@skynet.be>
References: <1412715735-6757-1-git-send-email-fabf@skynet.be>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Oct 2014 14:03:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>
Date: Tue,  7 Oct 2014 23:02:15 +0200

> static values are automatically initialized to 0
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
> V2: replace NULL by 0 in description

Applied, thanks Fabian.
