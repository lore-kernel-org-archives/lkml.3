Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbaLWFj1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 00:39:27 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:56646 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbaLWFj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 00:39:26 -0500
Date: Tue, 23 Dec 2014 16:39:09 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Amos Kong <akong@redhat.com>, m@bues.ch, mpm@selenic.com,
        amit.shah@redhat.com
Subject: [0/5] hwrng: Fix kref warning and underlying bugs
Message-ID: <20141223053909.GA28001@gondor.apana.org.au>
References: <20141223030956.GA26839@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141223030956.GA26839@wfg-t540p.sh.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 07:09:56PM -0800, Fengguang Wu wrote:
> Greetings,
> 
> 0day kernel testing robot got the below dmesg and the first bad commit is

Sigh, looks like more work is needed on this.

Here is a series of patches that should fix this along with the
underlying issue exposed by it and some other related problems.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
