Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895AbbASOh7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 09:37:59 -0500
Received: from mga01.intel.com ([192.55.52.88]:53790 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562AbbASOh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 09:37:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,427,1418112000"; 
   d="scan'208";a="639345505"
Message-ID: <54BD15F5.8@intel.com>
Date: Mon, 19 Jan 2015 06:34:29 -0800
From: Tadeusz Struk <tadeusz.struk@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Stephan Mueller <smueller@chronox.de>,
        "'Herbert Xu'" <herbert@gondor.apana.org.au>
CC: linux-crypto@vger.kernel.org, "'LKML'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: aesni: add setkey for driver-gcm-aes-aesni
References: <2587101.YvN0IxRmOH@tachyon.chronox.de>
In-Reply-To: <2587101.YvN0IxRmOH@tachyon.chronox.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2015 02:56 PM, Stephan Mueller wrote:
> The cipher registered as __driver-gcm-aes-aesni is never intended
> to be used directly by any caller. Instead it is a service mechanism to
> rfc4106-gcm-aesni.
> 
> The kernel crypto API unconditionally calls the registered setkey
> function. In case a caller erroneously uses __driver-gcm-aes-aesni a
> call to crypto_aead_setkey will cause a NULL pointer dereference without
> this patch.

Acked-by: Tadeusz Struk <tadeusz.struk@intel.com>
