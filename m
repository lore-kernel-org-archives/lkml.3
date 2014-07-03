Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107AbaGCOPx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 10:15:53 -0400
Received: from mail.atsec.com ([195.30.99.214]:50710 "EHLO mail.atsec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753665AbaGCOPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 10:15:49 -0400
X-Greylist: delayed 335 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jul 2014 10:15:49 EDT
From: Stephan Mueller <stephan.mueller@atsec.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2] crypto/fips: only panic on bad/missing crypto mod signatures
Date: Thu, 03 Jul 2014 16:10:07 +0200
Message-ID: <2891603.xs6W2pOOfS@tauon>
Organization: atsec information security GmbH
User-Agent: KMail/4.12.5 (Linux/3.14.8-200.fc20.x86_64; KDE/4.12.5; x86_64; ; )
In-Reply-To: <20140703111806.GE9748@hmsreliant.think-freely.org>
References: <1403896374-62781-1-git-send-email-jarod@redhat.com> <1404329850-35509-1-git-send-email-jarod@redhat.com> <20140703111806.GE9748@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 3. Juli 2014, 07:18:06 schrieb Neil Horman:
>On Wed, Jul 02, 2014 at 03:37:30PM -0400, Jarod Wilson wrote:
>> Per further discussion with NIST, the requirements for FIPS state
>> that
>> we only need to panic the system on failed kernel module signature
>> checks for crypto subsystem modules. This moves the fips-mode-only
>> module signature check out of the generic module loading code, into
>> the crypto subsystem, at points where we can catch both algorithm
>> module loads and mode module loads. At the same time, make
>> CONFIG_CRYPTO_FIPS dependent on CONFIG_MODULE_SIG, as this is
>> entirely necessary for FIPS mode.
>> 
>> v2: remove extraneous blank line, perform checks in static inline
>> function, drop no longer necessary fips.h include.
>> 
>> CC: Herbert Xu <herbert@gondor.apana.org.au>
>> CC: "David S. Miller" <davem@davemloft.net>
>> CC: Rusty Russell <rusty@rustcorp.com.au>
>> CC: Stephan Mueller <stephan.mueller@atsec.com>
>> CC: linux-crypto@vger.kernel.org
>> Signed-off-by: Jarod Wilson <jarod@redhat.com>
>
>Acked-by: Neil Horman <nhorman@tuxdriver.com>
Acked-by: Stephan Mueller <stephan.mueller@atsec.com>

