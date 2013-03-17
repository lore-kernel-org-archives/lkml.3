Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab3CQStz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 14:49:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60829 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755751Ab3CQSty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 14:49:54 -0400
Date: Sun, 17 Mar 2013 20:50:22 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: stable@kernel.org, rusty@rustcorp.com.au, jasowang@redhat.com,
        basil.gor@gmail.com, nab@risingtidesystems.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] vhost/net: fix heads usage of ubuf_info
Message-ID: <20130317185022.GA22517@redhat.com>
References: <20130317124609.GA25967@redhat.com>
 <20130317.142955.1114572401286297685.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130317.142955.1114572401286297685.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 17, 2013 at 02:29:55PM -0400, David Miller wrote:
> From: "Michael S. Tsirkin" <mst@redhat.com>
> Date: Sun, 17 Mar 2013 14:46:09 +0200
> 
> > ubuf info allocator uses guest controlled head as an index,
> > so a malicious guest could put the same head entry in the ring twice,
> > and we will get two callbacks on the same value.
> > To fix use upend_idx which is guaranteed to be unique.
> > 
> > Reported-by: Rusty Russell <rusty@rustcorp.com.au>
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> Applied and queued up for -stable, thanks.

OK I'll drop it from my tree then.
