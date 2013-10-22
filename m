Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab3JVR7b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 13:59:31 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58452 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384Ab3JVR73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 13:59:29 -0400
Date: Tue, 22 Oct 2013 13:59:28 -0400 (EDT)
Message-Id: <20131022.135928.2040131908206663695.davem@davemloft.net>
To: andi@firstfloor.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, netdev@vger.kernel.org
Subject: Re: [PATCH 11/11] asmlinkage, wan/sbni: Make inline assembler
 symbols visible and assembler global
From: David Miller <davem@davemloft.net>
In-Reply-To: <1382458346-24811-12-git-send-email-andi@firstfloor.org>
References: <1382458346-24811-1-git-send-email-andi@firstfloor.org>
	<1382458346-24811-12-git-send-email-andi@firstfloor.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 22 Oct 2013 10:59:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Tue, 22 Oct 2013 09:12:26 -0700

> From: Andi Kleen <ak@linux.intel.com>
> 
> - Inline assembler defining C callable code has to be global
> - The function has to be visible
> 
> Do this in wan/sbni
> 
> Cc: netdev@vger.kernel.org
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Is it really impossible to use the generic crc32 support instead of this
unsightly custom inline assembler?
