Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598Ab3AXGNi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 01:13:38 -0500
Received: from a.mx.secunet.com ([195.81.216.161]:39269 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771Ab3AXGNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 01:13:19 -0500
Date: Thu, 24 Jan 2013 07:13:15 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: linux-next: New trees - ipsec and ipsec-next
Message-ID: <20130124061315.GI9147@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 24 Jan 2013 06:13:16.0234 (UTC) FILETIME=[E5DE5AA0:01CDF9F9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Stephen,

could you please add the ipsec and ipsec-next tree to linux-next?

The ipsec tree is intended to cover fixes for the ipsec networking
subsystem and the ipsec-next tree to cover changes for ipsec with
linux-next as target.

The trees are located at:

git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec.git master
git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next.git master

The ipsec tree follows David Miller's net tree, the ipsec-next tree follows
the net-next tree. So they should be merged after net and net-next.

Both trees were pulled recently, so they are currently empty.

Thanks!
