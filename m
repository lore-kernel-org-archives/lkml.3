Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760024AbaKATMv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 15:12:51 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55147 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758135AbaKATMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 15:12:50 -0400
Date: Sat, 01 Nov 2014 15:12:44 -0400 (EDT)
Message-Id: <20141101.151244.1626989876697579410.davem@davemloft.net>
To: sudipm.mukherjee@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: mvpp2: fix possible memory leak
From: David Miller <davem@davemloft.net>
In-Reply-To: <1414841374-30537-1-git-send-email-sudipm.mukherjee@gmail.com>
References: <1414841374-30537-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 01 Nov 2014 12:12:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date: Sat,  1 Nov 2014 16:59:34 +0530

> we are allocating memory using kzalloc for struct mvpp2_prs_entry,
> but later when we are getting error we were just returning the error
> value without releasing the memory.
> 
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>

Applied, thanks.
