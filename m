Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120AbaG3VXX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 17:23:23 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36465 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbaG3VXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 17:23:21 -0400
Date: Wed, 30 Jul 2014 14:23:20 -0700 (PDT)
Message-Id: <20140730.142320.701181953514468731.davem@davemloft.net>
To: hannes@cmpxchg.org
Cc: akpm@linux-foundation.org, rdunlap@infradead.org,
        gregkh@linuxfoundation.org, mingo@elte.hu,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] Documentation: SubmittingPatches: overhaul changelog
 howto
From: David Miller <davem@davemloft.net>
In-Reply-To: <1406754661-15897-1-git-send-email-hannes@cmpxchg.org>
References: <1406754661-15897-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 30 Jul 2014 14:23:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>
Date: Wed, 30 Jul 2014 17:11:01 -0400

> Maintainers often repeat the same feedback on poorly written
> changelogs - describe the problem, justify your changes, quantify
> optimizations, describe user-visible changes - but our documentation
> on writing changelogs doesn't include these things.  Fix that.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: David S. Miller <davem@davemloft.net>
