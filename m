Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab3F0Hm6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 03:42:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:46407 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241Ab3F0Hm5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 03:42:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,950,1363158000"; 
   d="scan'208";a="336249501"
Message-ID: <1372318969.24799.70.camel@smile>
Subject: Re: [RFC Patch net-next 1/5] net: introduce generic union inet_addr
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Cong Wang <amwang@redhat.com>
Cc: netdev@vger.kernel.org, Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Date: Thu, 27 Jun 2013 10:42:49 +0300
In-Reply-To: <1372315398-19683-2-git-send-email-amwang@redhat.com>
References: <1372315398-19683-1-git-send-email-amwang@redhat.com>
	 <1372315398-19683-2-git-send-email-amwang@redhat.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-27 at 14:43 +0800, Cong Wang wrote: 
> Cc: Daniel Borkmann <dborkman@redhat.com>
> Signed-off-by: Cong Wang <amwang@redhat.com>

I was about to answer for the Daniel's patch about %pig.

Daniel, could you resend your patch series to the LKML, since it touches
lib/vsprintf.c.
Also, regarding to your patch 2/2, could it be possible to split it to
two parts: first substitutes SCTP macros not related to IP addresses and
second one is explicitly targeting against SCTP_DEBUG_PRINTK_IPADDR ?
By the way, in some places in 2/2 you didn't change open coded function
name to the '"%s: ...", __func__, ...'.

Cong, I don't think is a good idea to update lib/ code and net/ code in
one patch, since that are logically a bit different. lib/ code sounds
more common, it's better if it leads separately this series.


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
