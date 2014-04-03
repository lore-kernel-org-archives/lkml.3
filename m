Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161121AbaDCBiL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 21:38:11 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39615 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933675AbaDCBiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 21:38:10 -0400
Date: Wed, 02 Apr 2014 21:39:41 -0400 (EDT)
Message-Id: <20140402.213941.1530194697006154708.davem@davemloft.net>
To: m-komatsubara@ab.jp.nec.com
Cc: todd.fujinaka@intel.com, donald.c.skidmore@intel.com,
        linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net,
        netdev@vger.kernel.org, h-shimamoto@ct.jp.nec.com,
        h-baba@ax.jp.nec.com
Subject: Re: [E1000-devel] fail to add 64 VLANs or more when SR-IOV is
 enabled
From: David Miller <davem@davemloft.net>
In-Reply-To: <9DE5760509B7974286F38D93BF31DD62C7E125@BPXM13GP.gisp.nec.co.jp>
References: <9DE5760509B7974286F38D93BF31DD62C7DF93@BPXM13GP.gisp.nec.co.jp>
	<9B4A1B1917080E46B64F07F2989DADD652978166@ORSMSX102.amr.corp.intel.com>
	<9DE5760509B7974286F38D93BF31DD62C7E125@BPXM13GP.gisp.nec.co.jp>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 02 Apr 2014 18:38:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Madoka Komatsubara <m-komatsubara@ab.jp.nec.com>
Date: Thu, 3 Apr 2014 01:12:13 +0000

> Thank you for the quick response.
> How can I increase the limit？

It's a hardware limit, you cannot increase it.
