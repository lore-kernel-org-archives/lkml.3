Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762576Ab3JQTPH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 15:15:07 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46200 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762392Ab3JQTPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 15:15:03 -0400
Date: Thu, 17 Oct 2013 15:15:01 -0400 (EDT)
Message-Id: <20131017.151501.2148361256463511779.davem@davemloft.net>
To: michael.opdenacker@free-electrons.com
Cc: samuel@sortiz.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irda: update comment mentioning IRQF_DISABLED
From: David Miller <davem@davemloft.net>
In-Reply-To: <1381645591-9565-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1381645591-9565-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 17 Oct 2013 12:15:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Date: Sun, 13 Oct 2013 08:26:31 +0200

> This patch removes a comment mentioning IRQF_DISABLED,
> which is deprecated.
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

Applied to net-next, thanks.
