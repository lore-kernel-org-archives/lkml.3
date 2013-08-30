Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610Ab3H3EOf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 00:14:35 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:43610 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752699Ab3H3EOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 00:14:33 -0400
Message-ID: <1377836072.1928.137.camel@joe-AO722>
Subject: Re: [PATCH net-next] drivers:net: Convert
 dma_alloc_coherent(...__GFP_ZERO) to dma_zalloc_coherent
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        e1000-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org,
        b43-dev@lists.infradead.org, users@rt2x00.serialmonkey.com
Date: Thu, 29 Aug 2013 21:14:32 -0700
In-Reply-To: <20130829.220926.226210132086755040.davem@davemloft.net>
References: <dbbfc5e66dba7d2b63549d218407fb0c4031f2ed.1363367992.git.joe@perches.com>
	 <1377582323.2658.10.camel@joe-AO722>
	 <20130829.220926.226210132086755040.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-29 at 22:09 -0400, David Miller wrote:
> Applied, thanks a lot Joe.

Too bad I didn't know there was a dma_zalloc_coherent
the first time...

cheers, Joe

