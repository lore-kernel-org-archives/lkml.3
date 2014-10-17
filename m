Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbaJQPzv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 11:55:51 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40664 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111AbaJQPzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 11:55:49 -0400
Date: Fri, 17 Oct 2014 11:55:45 -0400 (EDT)
Message-Id: <20141017.115545.263842180599038435.davem@davemloft.net>
To: michael.opdenacker@free-electrons.com
Cc: chas@cmf.nrl.navy.mil, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atm: simplify lanai.c by using module_pci_driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1413359150-13552-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1413359150-13552-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 Oct 2014 08:55:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Date: Wed, 15 Oct 2014 09:45:50 +0200

> This simplifies the lanai.c driver by using
> the module_pci_driver() macro, at the expense
> of losing only debugging messages.
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

Applied, thanks.
