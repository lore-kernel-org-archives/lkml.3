Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454Ab3APU25 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 15:28:57 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38381 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593Ab3APU24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 15:28:56 -0500
Date: Wed, 16 Jan 2013 15:28:53 -0500 (EST)
Message-Id: <20130116.152853.1951022929656410901.davem@davemloft.net>
To: cascardo@linux.vnet.ibm.com
Cc: netdev@vger.kernel.org, dm@chelsio.com, linux-kernel@vger.kernel.org,
        steved@us.ibm.com, toml@us.ibm.com
Subject: Re: [PATCH] cxgb4: set coalesce parameters on all queues
From: David Miller <davem@davemloft.net>
In-Reply-To: <1358262910-23121-1-git-send-email-cascardo@linux.vnet.ibm.com>
References: <1358262910-23121-1-git-send-email-cascardo@linux.vnet.ibm.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Date: Tue, 15 Jan 2013 13:15:10 -0200

> The coalesce parameters was set only on the first queue, which caused
> interrupt rates to be larger on all the other queues.
> 
> This patch allows interrupt rates to be reduced for certain workloads
> and colaesce parameters by 41%.
> 
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>

Applied, thanks.
