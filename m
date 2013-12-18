Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614Ab3LRSti (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 13:49:38 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:55700 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab3LRSth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 13:49:37 -0500
Date: Wed, 18 Dec 2013 13:49:29 -0500 (EST)
Message-Id: <20131218.134929.1589481739063056702.davem@davemloft.net>
To: dan.j.williams@intel.com
Cc: netdev@vger.kernel.org, alexander.h.duyck@intel.com, dave.jiang@intel.com,
        vinod.koul@intel.com, whipple@securedatainnovations.ch,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org
Subject: Re: [PATCH 1/3] net_dma: mark broken
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAPcyv4i3emOCyVzDv_RPW79jb_RRFrRef1hKR2qY8ftW+oMj1w@mail.gmail.com>
References: <20131218001312.7847.9917.stgit@viggo.jf.intel.com>
	<20131218001538.7847.3289.stgit@viggo.jf.intel.com>
	<CAPcyv4i3emOCyVzDv_RPW79jb_RRFrRef1hKR2qY8ftW+oMj1w@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 18 Dec 2013 10:49:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 18 Dec 2013 10:05:51 -0800

> [ adding davem directly to cc ]
> 
> Dave, looking for an ack to take this through the dmaengine tree, and
> wondering if you want me to take patch 2 through dmaengine as well:

Please take it all:

Acked-by: David S. Miller <davem@davemloft.net>
