Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934994AbaEaARY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 20:17:24 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60728 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934624AbaEaARX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 20:17:23 -0400
Date: Fri, 30 May 2014 17:17:22 -0700 (PDT)
Message-Id: <20140530.171722.342011579545846279.davem@davemloft.net>
To: pebolle@tiscali.nl
Cc: trivial@kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [TRIVIAL] atm: remove commented out check
From: David Miller <davem@davemloft.net>
In-Reply-To: <1401203232.28714.10.camel@x220>
References: <1401203232.28714.10.camel@x220>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 30 May 2014 17:17:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Bolle <pebolle@tiscali.nl>
Date: Tue, 27 May 2014 17:07:12 +0200

> This preprocessor check is commented out ever since this file was added
> during the v2.3 development cycle. It is unclear what it purpose might
> have been. Whatever it was, it can safely be removed now.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Compile tested.
> 
> Perhaps someone on netdev knows what CONFIG_SINGLE_SIGITF might have
> been for. Not that it actually matters.

Yeah it can't actually matter, applied to net-next, thanks.
