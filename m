Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345AbaDKTS2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 15:18:28 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58288 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbaDKTS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 15:18:26 -0400
Date: Fri, 11 Apr 2014 15:18:20 -0400 (EDT)
Message-Id: <20140411.151820.2244532449368168368.davem@davemloft.net>
To: kys@microsoft.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Subject: Re: [PATCH net, V1 0/3] Fix issues with Heper-V network offload
 code
From: David Miller <davem@davemloft.net>
In-Reply-To: <1397080810-17953-1-git-send-email-kys@microsoft.com>
References: <1397080810-17953-1-git-send-email-kys@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 11 Apr 2014 12:18:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "K. Y. Srinivasan" <kys@microsoft.com>
Date: Wed,  9 Apr 2014 15:00:10 -0700

> WS2008 R2 does not support udp checksum offload. Furthermore, ws2012 and
> ws2012 r2 have issues offloading udp checksum from Linux guests.
> This patch-set addresses these issues as well as other bug fixes.
> Please apply.
> 
> In this version, I have addressed the comment from David Miller with reagards
> to COWing the skb prior to modifying the header (patch 3/3).

This looks a lot better, series applied, thanks.
