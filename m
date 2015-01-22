Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbbAVS1a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 13:27:30 -0500
Received: from mga01.intel.com ([192.55.52.88]:28299 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752707AbbAVS12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 13:27:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,450,1418112000"; 
   d="scan'208";a="666019626"
Message-ID: <54C1403D.1010608@intel.com>
Date: Thu, 22 Jan 2015 10:23:57 -0800
From: Tadeusz Struk <tadeusz.struk@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Stephan Mueller <smueller@chronox.de>
CC: Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
        "'LKML'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: aesni: add setkey for driver-gcm-aes-aesni
References: <2587101.YvN0IxRmOH@tachyon.chronox.de> <20150120031704.GB10475@gondor.apana.org.au> <40625395.stBBYbAQtz@tachyon.chronox.de>
In-Reply-To: <40625395.stBBYbAQtz@tachyon.chronox.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2015 05:25 PM, Stephan Mueller wrote:
>> Rather than adding a bogus setkey function, please fix this mess
>> properly by moving the top-level setkey function into the __driver
>> one where it should be.  Compare with how we handle it in the
>> ablk_helper which is pretty much the same thing.
> 
> Tadeusz, are you working on that update or shall I have a look?
> 
Hi,
No, I thought that the agreement was that we don't want to allow user
space to use these helpers directly, right? Am I missing something?
