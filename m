Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475AbbANF0Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 00:26:16 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:39206 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbbANF0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 00:26:12 -0500
Date: Wed, 14 Jan 2015 00:26:09 -0500 (EST)
Message-Id: <20150114.002609.1903467089677912749.davem@davemloft.net>
To: xander.huff@ni.com
Cc: nicolas.ferre@atmel.com, jaeden.amero@ni.com, rich.tollerton@ni.com,
        ben.shelton@ni.com, brad.mouring@ni.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] net/macb: Adding comments to various #defs to make
 interpretation easier
From: David Miller <davem@davemloft.net>
In-Reply-To: <1421187351-27279-1-git-send-email-xander.huff@ni.com>
References: <1421187351-27279-1-git-send-email-xander.huff@ni.com>
X-Mailer: Mew version 6.6 on Emacs 24.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 13 Jan 2015 21:26:11 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xander Huff <xander.huff@ni.com>
Date: Tue, 13 Jan 2015 16:15:50 -0600

> This change is to help improve at-a-glace knowledge of the purpose of the
> various Cadence MACB/GEM registers. Comments are more helpful for human
> readability than short acronyms.
> 
> Describe various #define varibles Cadence MACB/GEM registers as documented
> in Xilinix's "Zynq-7000 All Programmable SoC TechnicalReference Manual, v1.9.1
> (UG-585)"
> 
> Signed-off-by: Xander Huff <xander.huff@ni.com>

Applied.
