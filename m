Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759236Ab3D3IDA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 04:03:00 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41394 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab3D3ICz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 04:02:55 -0400
Date: Tue, 30 Apr 2013 04:02:51 -0400 (EDT)
Message-Id: <20130430.040251.1648116137288414643.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, ariele@broadcom.com,
        yuvalmin@broadcom.com, eilong@broadcom.com
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130426132447.c7b06622240088ccad366b03@canb.auug.org.au>
References: <20130426132447.c7b06622240088ccad366b03@canb.auug.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 30 Apr 2013 01:02:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 26 Apr 2013 13:24:47 +1000

> Today's linux-next merge of the net-next tree got a conflict in
> drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c between commit
> ecf01c22be03 ("bnx2x: Prevent NULL pointer dereference in kdump") from
> the net tree and commit 5b0752c863d7 ("bnx2x: Fix VF statistics") from
> the net-next tree.
> 
> I am not sure about this, but I just used the net tree version but I
> assume something more may be needed and can carry the fix as necessary (no
> action is required).

I've just resolved this when I merged net into net-next.
