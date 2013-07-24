Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689Ab3GXPAF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 11:00:05 -0400
Received: from s15338416.onlinehome-server.info ([87.106.68.36]:36875 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab3GXPAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 11:00:01 -0400
Date: Wed, 24 Jul 2013 17:00:00 +0200
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Jerry Snitselaar <jerry.snitselaar@oracle.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fib_trie: potential out of bounds access in trie_show_stats()
Message-ID: <20130724150000.GB22402@order.stressinduktion.org>
Mail-Followup-To: Jerry Snitselaar <jerry.snitselaar@oracle.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1374519718-8299-1-git-send-email-jerry.snitselaar@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1374519718-8299-1-git-send-email-jerry.snitselaar@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 12:01:58PM -0700, Jerry Snitselaar wrote:
> With the <= max condition in the for loop, it will be always go 1
> element further than needed. If the condition for the while loop is
> never met, then max is MAX_STAT_DEPTH, and for loop will walk off the
> end of nodesizes[].
> 
> Signed-off-by: Jerry Snitselaar <jerry.snitselaar@oracle.com>

Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>

Thanks,

  Hannes

