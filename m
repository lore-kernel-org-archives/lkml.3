Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbbAVV7M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 16:59:12 -0500
Received: from mga09.intel.com ([134.134.136.24]:65400 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbbAVV7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 16:59:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,451,1418112000"; 
   d="scan'208";a="674407280"
Message-ID: <54C171C1.1070000@intel.com>
Date: Thu, 22 Jan 2015 13:55:13 -0800
From: Tadeusz Struk <tadeusz.struk@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Stephan Mueller <smueller@chronox.de>
CC: Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
        "'LKML'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: aesni: add setkey for driver-gcm-aes-aesni
References: <2587101.YvN0IxRmOH@tachyon.chronox.de> <40625395.stBBYbAQtz@tachyon.chronox.de> <54C1403D.1010608@intel.com> <1876694.bQrN48MF7q@tauon>
In-Reply-To: <1876694.bQrN48MF7q@tauon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2015 01:20 PM, Stephan Mueller wrote:
> That would be correct. But if I understood Herbert correctly, he is 
> creating a patch that disables these service ciphers for general usage.

Yes, and this should also implicitly fix the problem with user space.
Thanks,
Tadeusz
