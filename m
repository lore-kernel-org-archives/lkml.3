Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab3GJSwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 14:52:19 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44074 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab3GJSwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 14:52:17 -0400
Date: Wed, 10 Jul 2013 11:52:15 -0700 (PDT)
Message-Id: <20130710.115215.1793423861402826221.davem@davemloft.net>
To: mtk.manpages@gmail.com
Cc: eliezer.tamir@linux.intel.com, linux-man@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        akpm@linux-foundation.org, eliezer@tamir.org.il
Subject: Re: [PATCH v2] socket.7: add description for SO_BUSY_POLL
From: David Miller <davem@davemloft.net>
In-Reply-To: <51DDA1DC.2020306@gmail.com>
References: <20130710141835.15799.61657.stgit@ladj378.jer.intel.com>
	<51DDA1DC.2020306@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Wed, 10 Jul 2013 20:03:08 +0200

> On 07/10/13 16:18, Eliezer Tamir wrote:
>> Add description for the SO_BUSY_POLL socket option to the socket(7) manpage.
>> 
>> v2
>> fixed typos reported by Rasmus Villemoes
> 
> Eliezer,
> 
> What's the status of this feature. A quick grep seems to show
> that the feature is not yet in mainline. What is the plan?

It's in Linus's tree.
