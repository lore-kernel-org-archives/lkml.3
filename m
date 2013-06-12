Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758118Ab3FLWMQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 18:12:16 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60935 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756629Ab3FLWMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 18:12:14 -0400
Date: Wed, 12 Jun 2013 15:12:05 -0700 (PDT)
Message-Id: <20130612.151205.1822920389019274346.davem@davemloft.net>
To: eliezer.tamir@linux.intel.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jesse.brandeburg@intel.com, donald.c.skidmore@intel.com,
        e1000-devel@lists.sourceforge.net, willemb@google.com,
        erdnetdev@gmail.com, bhutchings@solarflare.com, andi@firstfloor.org,
        hpa@zytor.com, eilong@broadcom.com, or.gerlitz@gmail.com,
        amirv@mellanox.com, eliezer@tamir.org.il
Subject: Re: [PATCH net-next 1/2] net: remove NET_LL_RX_POLL config menue
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130611142428.17879.33582.stgit@ladj378.jer.intel.com>
References: <20130611142415.17879.75569.stgit@ladj378.jer.intel.com>
	<20130611142428.17879.33582.stgit@ladj378.jer.intel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Date: Tue, 11 Jun 2013 17:24:28 +0300

>  	depends on X86_TSC

Wait a second, I didn't notice this before.  There needs to be a better
way to test for the accuracy you need, or if the issue is lack of a proper
API for cycle counter reading, fix that rather than add ugly arch
specific dependencies to generic networking code.
