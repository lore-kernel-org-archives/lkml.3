Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454AbbAVWeR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 17:34:17 -0500
Received: from mga14.intel.com ([192.55.52.115]:13297 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105AbbAVWeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 17:34:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,451,1418112000"; 
   d="scan'208";a="655153850"
Message-ID: <54C17A17.8060306@intel.com>
Date: Thu, 22 Jan 2015 14:30:47 -0800
From: Tadeusz Struk <tadeusz.struk@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org,
        "'LKML'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: aesni: add setkey for driver-gcm-aes-aesni
References: <2587101.YvN0IxRmOH@tachyon.chronox.de> <20150120031704.GB10475@gondor.apana.org.au> <40625395.stBBYbAQtz@tachyon.chronox.de> <54C1403D.1010608@intel.com> <20150122222302.GA10895@gondor.apana.org.au>
In-Reply-To: <20150122222302.GA10895@gondor.apana.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2015 02:23 PM, Herbert Xu wrote:
> Yes but we should also fix this so that it's a proper aead
> algorithm.
Ok, I'll do that.
Thanks,
Tadeusz
