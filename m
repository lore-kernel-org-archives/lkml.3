Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab3HUUYY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 16:24:24 -0400
Received: from relay3.sgi.com ([192.48.152.1]:57376 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751985Ab3HUUYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 16:24:23 -0400
Date: Wed, 21 Aug 2013 15:24:17 -0500
From: Ben Myers <bpm@sgi.com>
To: Jeremy Kerr <jk@ozlabs.org>, Dwight Engen <dwight.engen@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: cbe-oss-dev@lists.ozlabs.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
        linux-next@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: Re: [PATCH] powerpc/spufs: convert userns uid/gid mount options to
 kuid/kgid
Message-ID: <20130821202417.GN5262@sgi.com>
References: <20130820172052.1f0d89ddf6a1a40ef70333fd@canb.auug.org.au>
 <20130821155654.GI5262@sgi.com>
 <20130821143351.5840d556@oracle.com>
 <201308212205.27789.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201308212205.27789.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 10:05:27PM +0200, Arnd Bergmann wrote:
> On Wednesday 21 August 2013, Dwight Engen wrote:
> > 
> > Acked-by: Jeremy Kerr <jk@ozlabs.org>
> > Tested-by: Jeremy Kerr <jk@ozlabs.org>
> > Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
> 
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>

Applied.

Thanks,
	-Ben

