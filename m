Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933662Ab3E1IvJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 04:51:09 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47364 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933608Ab3E1IvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 04:51:08 -0400
Date: Tue, 28 May 2013 01:51:05 -0700 (PDT)
Message-Id: <20130528.015105.1513437101791265718.davem@davemloft.net>
To: mingo@kernel.org
Cc: luto@amacapital.net, linux-kernel@vger.kernel.org, x86@kernel.org,
        trinity@vger.kernel.org
Subject: Re: [PATCH 0/5] x86: oops on uaccess faults outside of user
 addresses
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130528082514.GA29730@gmail.com>
References: <cover.1369177867.git.luto@amacapital.net>
	<20130522.142847.791230763817666795.davem@davemloft.net>
	<20130528082514.GA29730@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>
Date: Tue, 28 May 2013 10:25:14 +0200

> 
> * David Miller <davem@davemloft.net> wrote:
> 
>> Please don't mix networking and non-networking changes into a patch
>> series.
> 
> As explained in 0/5 the networking fix justifies the first 4 patches. The 
> networking fix is independent of the first 4 patches.
> 
>> Submit the networking patch to netdev@vger.kernel.org
> 
> He Cc:-ed the patch to netdev@vger.kernel.org. If you agree with it then 
> the fix should probably be picked up ASAP.

He submitted it as part of a series which implies that it belongs together
with the others.

If it does not, he should submit it seperately.

If they belong together, then the entire series should be CC:'d to netdev
so that networking developers can see all of the context and participate
in the patches that the networking "enables".
