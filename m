Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226AbaCHX6D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 18:58:03 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:55146 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbaCHX6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 18:58:01 -0500
Date: Sat, 08 Mar 2014 18:57:59 -0500 (EST)
Message-Id: <20140308.185759.494043114567727021.davem@davemloft.net>
To: zoltan.kiss@citrix.com
Cc: ian.campbell@citrix.com, wei.liu2@citrix.com,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jonathan.davies@citrix.com,
        andrew.bennieston@citrix.com
Subject: Re: [PATCH net-next v7 0/9] xen-netback: TX grant mapping with
 SKBTX_DEV_ZEROCOPY instead of copy
From: David Miller <davem@davemloft.net>
In-Reply-To: <531B2B3E.5050800@citrix.com>
References: <1394142511-14827-1-git-send-email-zoltan.kiss@citrix.com>
	<20140307.160552.282750558679341658.davem@davemloft.net>
	<531B2B3E.5050800@citrix.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 08 Mar 2014 15:58:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zoltan Kiss <zoltan.kiss@citrix.com>
Date: Sat, 8 Mar 2014 14:37:50 +0000

> Maybe you mixed up mine with that? But that's also not eligible to be
> applied yet.

I can always revert the series if there are major objections.
