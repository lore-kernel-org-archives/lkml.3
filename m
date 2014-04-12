Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644AbaDLU6W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 16:58:22 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38700 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756483AbaDLU6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 16:58:20 -0400
Date: Sat, 12 Apr 2014 16:58:18 -0400 (EDT)
Message-Id: <20140412.165818.1540640354445899640.davem@davemloft.net>
To: avagin@openvz.org
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, brouer@redhat.com, pablo@netfilter.org,
        kaber@trash.net, kadlec@blackhole.kfki.hu
Subject: Re: [PATCH] netfilter: conntrack: initialize net.ct.generation
From: David Miller <davem@davemloft.net>
In-Reply-To: <1397237660-30632-1-git-send-email-avagin@openvz.org>
References: <1397237660-30632-1-git-send-email-avagin@openvz.org>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 12 Apr 2014 13:58:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrey Vagin <avagin@openvz.org>
Date: Fri, 11 Apr 2014 21:34:20 +0400

> [  251.920788] INFO: trying to register non-static key.

I'll let Pablo integrate this.
