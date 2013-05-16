Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694Ab3EPDLD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 23:11:03 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40761 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab3EPDK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 23:10:59 -0400
Date: Wed, 15 May 2013 20:10:55 -0700 (PDT)
Message-Id: <20130515.201055.1401062016041347476.davem@davemloft.net>
To: rusty@rustcorp.com.au
Cc: nab@linux-iscsi.org, asias@redhat.com, mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        target-devel@vger.kernel.org, sfr@canb.auug.org.au,
        rdunlap@infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] vhost-scsi: Depend on NET for memcpy_fromiovec
From: David Miller <davem@davemloft.net>
In-Reply-To: <871u9724vp.fsf@rustcorp.com.au>
References: <8761yk254u.fsf@rustcorp.com.au>
	<1368657450.6899.29.camel@haakon3.risingtidesystems.com>
	<871u9724vp.fsf@rustcorp.com.au>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Wed, 15 May 2013 20:10:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 16 May 2013 09:05:38 +0930

> memcpy_fromiovec() has nothing to do with networking: that was just the
> first user.  Note that crypto/algif_skcipher.c also uses it.  The
> obvious answer is to move it into lib/.

+1
