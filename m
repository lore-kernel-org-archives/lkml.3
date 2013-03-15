Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345Ab3COMZR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 08:25:17 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46601 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304Ab3COMZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 08:25:15 -0400
Date: Fri, 15 Mar 2013 08:25:30 -0400 (EDT)
Message-Id: <20130315.082530.1920500635070584515.davem@davemloft.net>
To: grantr@vmware.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        pv-drivers@vmware.com
Subject: Re: [PATCH] VSOCK: Support VM sockets connected to the hypervisor.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1363117219-21911-1-git-send-email-grantr@vmware.com>
References: <1363117219-21911-1-git-send-email-grantr@vmware.com>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Fri, 15 Mar 2013 05:25:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Reilly Grant <grantr@vmware.com>
Date: Tue, 12 Mar 2013 12:40:19 -0700

> The resource ID used for VM socket control packets (0) is already
> used for the VMCI_GET_CONTEXT_ID hypercall so a new ID (15) must be
> used when the guest sends these datagrams to the hypervisor.
> 
> The hypervisor context ID must also be removed from the internal
> blacklist.
> 
> Signed-off-by: Reilly Grant <grantr@vmware.com>
> Acked-by: Andy King <acking@vmware.com>

Applied, thanks.
