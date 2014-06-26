Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968AbaFZPFc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 11:05:32 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:38169 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430AbaFZPF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 11:05:29 -0400
Message-ID: <53AC36B8.8000303@infradead.org>
Date: Thu, 26 Jun 2014 08:05:28 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
CC: linux-kernel@vger.kernel.org, qat-linux@intel.com
Subject: Re: linux-next: Tree for Jun 26 (crypto/qat)
References: <20140626164130.4d01a3b2@canb.auug.org.au> <53AC366C.5030504@infradead.org>
In-Reply-To: <53AC366C.5030504@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/14 08:04, Randy Dunlap wrote:
> On 06/25/14 23:41, Stephen Rothwell wrote:
>> Hi all,
>>
>> The powerpc allyesconfig is again broken more than usual.
>>
>> Changes since 20140625:
>>
> 
> on x86_64:
> 
>   CC      drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.o
> ../drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c: In function 'adf_enable_error_correction':
> ../drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c:166:3: error: implicit declaration of function '__raw_readl' [-Werror=implicit-function-declaration]
> ../drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c:168:3: error: implicit declaration of function '__raw_writel' [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors
> make[5]: *** [drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.o] Error 1
> 
> 
> 

Sorry, I missed another one:
../drivers/crypto/qat/qat_dh895xcc/adf_hw_arbiter.c:100:3: error: implicit declaration of function '__raw_writel' [-Werror=implicit-function-declaration]


-- 
~Randy
