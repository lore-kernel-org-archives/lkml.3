Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183AbaFFULM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 16:11:12 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:59929 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbaFFULI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 16:11:08 -0400
Date: Fri, 06 Jun 2014 13:11:07 -0700 (PDT)
Message-Id: <20140606.131107.70145995747531058.davem@davemloft.net>
To: thomas.lendacky@amd.com
Cc: netdev@vger.kernel.org, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] amd-xgbe: Remove unnecessary include
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140606135219.32017.96806.stgit@tlendack-t1.amdoffice.net>
References: <20140606135219.32017.96806.stgit@tlendack-t1.amdoffice.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 06 Jun 2014 13:11:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>
Date: Fri, 6 Jun 2014 08:52:19 -0500

> The include of asm/cputype.h breaks the powerpc build. This
> include was accidentally left in from driver debugging and
> can be removed.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>

Since Stephen Rothwell reported this problem to you, you should
give him credit for this using the "Reported-by: " tag.

I took care of it this time, but you must do this in the future.
