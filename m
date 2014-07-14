Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbaGNMvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 08:51:38 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:38087 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781AbaGNMuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 08:50:13 -0400
Date: Mon, 14 Jul 2014 20:50:06 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Amit Shah <amit.shah@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, keescook@chromium.org,
        jason@lakedaemon.net
Subject: Re: [PATCH v3 0/2] hwrng, virtio-rng: init-time fixes
Message-ID: <20140714125006.GA9958@gondor.apana.org.au>
References: <cover.1404987133.git.amit.shah@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1404987133.git.amit.shah@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 03:42:33PM +0530, Amit Shah wrote:
> v3:
>  - Kees Cook pointed out a weird side-effect: devices which have
>    ->init() registered get their randomness added to the system each
>    time they're switched in, but devices that don't have the init
>    callback don't contribute to system randomness more than once.  The
>    weirdness is resolved here by using the randomness each time
>    hwrng_init() is attempted, irrespective of the existence of the
>    device's ->init() callback.

All applied to crypto.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
