Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932612Ab3DBSju (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 14:39:50 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45192 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106Ab3DBSjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 14:39:49 -0400
Date: Tue, 02 Apr 2013 14:39:46 -0400 (EDT)
Message-Id: <20130402.143946.956982729576009415.davem@davemloft.net>
To: grantr@vmware.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        pv-drivers@vmware.com
Subject: Re: [PATCH] VSOCK: Handle changes to the VMCI context ID.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1364841712-22810-1-git-send-email-grantr@vmware.com>
References: <1364841712-22810-1-git-send-email-grantr@vmware.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 02 Apr 2013 11:39:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Reilly Grant <grantr@vmware.com>
Date: Mon,  1 Apr 2013 11:41:52 -0700

> The VMCI context ID of a virtual machine may change at any time. There
> is a VMCI event which signals this but datagrams may be processed before
> this is handled. It is therefore necessary to be flexible about the
> destination context ID of any datagrams received. (It can be assumed to
> be correct because it is provided by the hypervisor.) The context ID on
> existing sockets should be updated to reflect how the hypervisor is
> currently referring to the system.
> 
> Signed-off-by: Reilly Grant <grantr@vmware.com>
> Acked-by: Andy King <acking@vmware.com>

Applied, thanks.
