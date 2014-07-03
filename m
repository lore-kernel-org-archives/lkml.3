Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125AbaGCLSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 07:18:18 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38019 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbaGCLSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 07:18:16 -0400
Date: Thu, 3 Jul 2014 07:18:06 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Jarod Wilson <jarod@redhat.com>
Cc: linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Stephan Mueller <stephan.mueller@atsec.com>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2] crypto/fips: only panic on bad/missing crypto mod
 signatures
Message-ID: <20140703111806.GE9748@hmsreliant.think-freely.org>
References: <1403896374-62781-1-git-send-email-jarod@redhat.com>
 <1404329850-35509-1-git-send-email-jarod@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404329850-35509-1-git-send-email-jarod@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 03:37:30PM -0400, Jarod Wilson wrote:
> Per further discussion with NIST, the requirements for FIPS state that
> we only need to panic the system on failed kernel module signature checks
> for crypto subsystem modules. This moves the fips-mode-only module
> signature check out of the generic module loading code, into the crypto
> subsystem, at points where we can catch both algorithm module loads and
> mode module loads. At the same time, make CONFIG_CRYPTO_FIPS dependent on
> CONFIG_MODULE_SIG, as this is entirely necessary for FIPS mode.
> 
> v2: remove extraneous blank line, perform checks in static inline
> function, drop no longer necessary fips.h include.
> 
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> CC: "David S. Miller" <davem@davemloft.net>
> CC: Rusty Russell <rusty@rustcorp.com.au>
> CC: Stephan Mueller <stephan.mueller@atsec.com>
> CC: linux-crypto@vger.kernel.org
> Signed-off-by: Jarod Wilson <jarod@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>

