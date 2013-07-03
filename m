Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317Ab3GCGxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 02:53:16 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57794 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab3GCGxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 02:53:15 -0400
Date: Tue, 02 Jul 2013 23:53:12 -0700 (PDT)
Message-Id: <20130702.235312.1962706449684547854.davem@davemloft.net>
To: eliezer.tamir@linux.intel.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, willemb@google.com,
        erdnetdev@gmail.com, andi@firstfloor.org, hpa@zytor.com,
        eliezer@tamir.org.il
Subject: Re: [PATCH net-next] net: lls fix build with allnoconfig
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130703034124.28666.55448.stgit@ladj378.jer.intel.com>
References: <20130703034124.28666.55448.stgit@ladj378.jer.intel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Date: Wed, 03 Jul 2013 06:41:24 +0300

> correct placeholder declarations to prevent build breakage when
> !CONFIG_NET_LL_RX_POLL
> 
> Signed-off-by: Eliezer Tamir <eliezer.tamir@linux.intel.com>

Applied, thanks.
