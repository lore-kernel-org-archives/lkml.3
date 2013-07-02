Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297Ab3GBWye (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 18:54:34 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54789 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755240Ab3GBWyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 18:54:32 -0400
Date: Tue, 02 Jul 2013 15:54:29 -0700 (PDT)
Message-Id: <20130702.155429.367173377456020422.davem@davemloft.net>
To: eliezer.tamir@linux.intel.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, willemb@google.com,
        erdnetdev@gmail.com, andi@firstfloor.org, hpa@zytor.com,
        eliezer@tamir.org.il
Subject: Re: [PATCH net-next v2 (repost)] net: convert lls to use
 time_in_range()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130702202247.31615.19867.stgit@ladj378.jer.intel.com>
References: <20130702202247.31615.19867.stgit@ladj378.jer.intel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Date: Tue, 02 Jul 2013 23:22:47 +0300

> Time in range will fail safely if we move to a different cpu with an
> extremely large clock skew.
> Add time_in_range64() and convert lls to use it.
> 
> changelog:
> v2
> - fixed double call to sched_clock in can_poll_ll
> - fixed checkpatchisms
> 
> Signed-off-by: Eliezer Tamir <eliezer.tamir@linux.intel.com>

Much better, applied, thanks.
