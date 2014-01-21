Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594AbaAUWfb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 17:35:31 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:37679 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815AbaAUWfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 17:35:22 -0500
Date: Tue, 21 Jan 2014 14:35:21 -0800 (PST)
Message-Id: <20140121.143521.2225558851109629128.davem@davemloft.net>
To: paul.gortmaker@windriver.com
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        sparclinux@vger.kernel.org
Subject: Re: [PATCH 35/73] sparc: delete non-required instances of include
 <linux/init.h>
From: David Miller <davem@davemloft.net>
In-Reply-To: <1390339396-3479-36-git-send-email-paul.gortmaker@windriver.com>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
	<1390339396-3479-36-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Tue, 21 Jan 2014 16:22:38 -0500

> None of these files are actually using any __init type directives
> and hence don't need to include <linux/init.h>.  Most are just a
> left over from __devinit and __cpuinit removal, or simply due to
> code getting copied from one driver to the next.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: sparclinux@vger.kernel.org
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Acked-by: David S. Miller <davem@davemloft.net>
