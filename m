Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711Ab3APTqE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 14:46:04 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:60365 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242Ab3APTqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 14:46:01 -0500
Message-ID: <1358365541.4593.190.camel@falcor1>
Subject: Re: [RFC 0/1] ima/evm: signature verification support using
 asymmetric keys
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Cc: dhowells@redhat.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 16 Jan 2013 14:45:41 -0500
In-Reply-To: <cover.1358246017.git.dmitry.kasatkin@intel.com>
References: <cover.1358246017.git.dmitry.kasatkin@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011619-3620-0000-0000-000000EA1FD1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-15 at 12:34 +0200, Dmitry Kasatkin wrote:
> Asymmetric keys were introduced in linux-3.7 to verify the signature on signed
> kernel modules.  The asymmetric keys infrastructure abstracts the signature
> verification from the crypto details.  This patch adds IMA/EVM signature
> verification using asymmetric keys.  Support for additional signature
> verification methods can now be delegated to the asymmetric key infrastructure.
> 
> Although the module signature header and the IMA/EVM signature header could
> use the same header format, to minimize the signature length and save space
> in the extended attribute, the IMA/EVM header format is different than the
> module signature header.  The main difference is that the key identifier is
> a sha1[12 - 19] hash of the key modulus and exponent and similar to the current
> implementation. The only purpose is to identify corresponding key in the kernel
> keyring. ima-evm-utils was updated to support the new signature format.

David, are you ok with how support for asymmetric keys is being added to
EVM/IMA-appraisal for verifying signatures?  Any comments?

thanks,

Mimi

