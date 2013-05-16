Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab3EPGqh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 02:46:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866Ab3EPGqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 02:46:34 -0400
Date: Thu, 16 May 2013 09:46:21 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: rusty@rustcorp.com.au, nab@linux-iscsi.org, asias@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        target-devel@vger.kernel.org, sfr@canb.auug.org.au,
        rdunlap@infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] vhost-scsi: Depend on NET for memcpy_fromiovec
Message-ID: <20130516064620.GB26995@redhat.com>
References: <8761yk254u.fsf@rustcorp.com.au>
 <1368657450.6899.29.camel@haakon3.risingtidesystems.com>
 <871u9724vp.fsf@rustcorp.com.au>
 <20130515.201055.1401062016041347476.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130515.201055.1401062016041347476.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 08:10:55PM -0700, David Miller wrote:
> From: Rusty Russell <rusty@rustcorp.com.au>
> Date: Thu, 16 May 2013 09:05:38 +0930
> 
> > memcpy_fromiovec() has nothing to do with networking: that was just the
> > first user.  Note that crypto/algif_skcipher.c also uses it.  The
> > obvious answer is to move it into lib/.
> 
> +1

Rusty sent a patch that does this:
http://patchwork.ozlabs.org/patch/244207/

David, looks like you weren't CC'd.
If you agree could you please Ack that patch and then I can merge it
through the vhost tree?
Or if you prefer merge it directly and I'll sort out the dependencies...

Thanks,

-- 
MST
