Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873AbaLFHAJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 02:00:09 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:49139 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbaLFHAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 02:00:07 -0500
Date: Sat, 6 Dec 2014 14:59:46 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Amos Kong <akong@redhat.com>
Cc: virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
        kvm@vger.kernel.org, m@bues.ch, mpm@selenic.com, amit.shah@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 0/6] fix hw_random stuck
Message-ID: <20141206065946.GA2320@gondor.apana.org.au>
References: <1417839402-13490-1-git-send-email-akong@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417839402-13490-1-git-send-email-akong@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 06, 2014 at 12:16:36PM +0800, Amos Kong wrote:
> When I hotunplug a busy virtio-rng device or try to access
> hwrng attributes in non-smp guest, it gets stuck.

Please resend these via the linux-crypto mailing list so they
can be picked up by patchwork.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
