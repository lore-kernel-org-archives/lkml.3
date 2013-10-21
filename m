Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab3JUWrs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 18:47:48 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44330 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801Ab3JUWrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 18:47:45 -0400
Date: Mon, 21 Oct 2013 18:47:43 -0400 (EDT)
Message-Id: <20131021.184743.431974482232204403.davem@davemloft.net>
To: michael.opdenacker@free-electrons.com
Cc: divy@chelsio.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] chelsio: remove duplicate defines
From: David Miller <davem@davemloft.net>
In-Reply-To: <1382332189-5596-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1382332189-5596-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 21 Oct 2013 15:47:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Date: Mon, 21 Oct 2013 07:09:49 +0200

> This removes multiple duplicate definitions
> in drivers/net/ethernet/chelsio/cxgb3/regs.h
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

Applied.
