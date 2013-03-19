Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933323Ab3CSUQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 16:16:34 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47916 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932166Ab3CSUQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 16:16:33 -0400
Date: Tue, 19 Mar 2013 16:16:31 -0400 (EDT)
Message-Id: <20130319.161631.1063411526469621480.davem@davemloft.net>
To: pebolle@tiscali.nl
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc: delete "if !ULTRA_HAS_POPULATION_COUNT"
From: David Miller <davem@davemloft.net>
In-Reply-To: <1363120519.3137.148.camel@x61.thuisdomein>
References: <1363120519.3137.148.camel@x61.thuisdomein>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 19 Mar 2013 13:16:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Bolle <pebolle@tiscali.nl>
Date: Tue, 12 Mar 2013 21:35:19 +0100

> Commit 2d78d4beb64eb07d50665432867971c481192ebf ("[PATCH] bitops:
> sparc64: use generic bitops") made the default of GENERIC_HWEIGHT depend
> on !ULTRA_HAS_POPULATION_COUNT. But since there's no Kconfig symbol with
> that name, this always evaluates to true. Delete this dependency.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Applied, thanks Paul.
