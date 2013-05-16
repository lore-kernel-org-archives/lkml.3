Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369Ab3EPJK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 05:10:27 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46137 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab3EPJKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 05:10:24 -0400
Date: Thu, 16 May 2013 02:10:20 -0700 (PDT)
Message-Id: <20130516.021020.886926151198681453.davem@davemloft.net>
To: mst@redhat.com
Cc: rusty@rustcorp.com.au, nab@linux-iscsi.org, asias@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        target-devel@vger.kernel.org, sfr@canb.auug.org.au,
        rdunlap@infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] vhost-scsi: Depend on NET for memcpy_fromiovec
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130516064620.GB26995@redhat.com>
References: <871u9724vp.fsf@rustcorp.com.au>
	<20130515.201055.1401062016041347476.davem@davemloft.net>
	<20130516064620.GB26995@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Thu, 16 May 2013 02:10:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Thu, 16 May 2013 09:46:21 +0300

> On Wed, May 15, 2013 at 08:10:55PM -0700, David Miller wrote:
>> From: Rusty Russell <rusty@rustcorp.com.au>
>> Date: Thu, 16 May 2013 09:05:38 +0930
>> 
>> > memcpy_fromiovec() has nothing to do with networking: that was just the
>> > first user.  Note that crypto/algif_skcipher.c also uses it.  The
>> > obvious answer is to move it into lib/.
>> 
>> +1
> 
> Rusty sent a patch that does this:
> http://patchwork.ozlabs.org/patch/244207/
> 
> David, looks like you weren't CC'd.
> If you agree could you please Ack that patch and then I can merge it
> through the vhost tree?
> Or if you prefer merge it directly and I'll sort out the dependencies...

Acked-by: David S. Miller <davem@davemloft.net>
