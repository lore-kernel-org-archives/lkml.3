Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbaCZKJX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 06:09:23 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:9874 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbaCZKJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 06:09:21 -0400
X-IronPort-AV: E=Sophos;i="4.97,734,1389744000"; 
   d="scan'208";a="113668997"
Message-ID: <1395828547.22808.28.camel@kazak.uk.xensource.com>
Subject: Re: [PATCH] ixen-netback: fix trivial printf format build warning
From: Ian Campbell <Ian.Campbell@citrix.com>
To: SeongJae Park <sj38.park@gmail.com>
CC: <trivial@kernel.org>, <wei.liu2@citrix.com>,
        <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Date: Wed, 26 Mar 2014 10:09:07 +0000
In-Reply-To: <1395806210-23528-1-git-send-email-sj38.park@gmail.com>
References: <1395806210-23528-1-git-send-email-sj38.park@gmail.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.2.80]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-26 at 12:56 +0900, SeongJae Park wrote:
> Fix following trivial build warning:
> 
> drivers/net/xen-netback/netback.c: In function ‘xenvif_tx_dealloc_action’:
> drivers/net/xen-netback/netback.c:1585:8: warning:
> format ‘%x’ expects argument of type
>  ‘unsigned int’, but argument 3 has type ‘long int’ [-Wformat=]
>         gop - vif->tx_unmap_ops, ret);
>         ^
> 
> Signed-off-by: SeongJae Park <sj38.park@gmail.com>

Thanks but davem indicated overnight that he has already pushed a
suitable fix to net-next.

Ian.


