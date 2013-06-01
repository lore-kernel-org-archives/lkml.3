Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262Ab3FAAeJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 20:34:09 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43365 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932107Ab3FAAeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 20:34:05 -0400
Date: Fri, 31 May 2013 17:34:03 -0700 (PDT)
Message-Id: <20130531.173403.773282788816605540.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: Re: [PATCH net] hyperv: Fix vlan_proto setting in
 netvsc_recv_callback()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1369757756-24572-1-git-send-email-haiyangz@microsoft.com>
References: <1369757756-24572-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Tue, 28 May 2013 09:15:56 -0700

> Since the recent addition of 8021AD, we need to set the new field vlan_proto in
> sk_buff. Otherwise, it will trigger BUG() call in vlan_proto_idx().
> 
> This patch fixes the problem.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>

Applied, thanks.
