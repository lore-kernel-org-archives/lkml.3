Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650Ab3LSTfP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 14:35:15 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34835 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522Ab3LSTfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 14:35:13 -0500
Message-ID: <52B34A6D.7010903@infradead.org>
Date: Thu, 19 Dec 2013 11:35:09 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Tom Lendacky <thomas.lendacky@amd.com>, Jim Davis <jim.epost@gmail.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: randconfig build error with next-20131210, in drivers/crypto/ccp/ccp-pci.c
References: <CA+r1ZhhhUWhMqeyS0J7V5j-iYtCk24gszpJFif8hF2cwr5K6hg@mail.gmail.com> <1785749.ip5jsEzFz7@tlendack-t1>
In-Reply-To: <1785749.ip5jsEzFz7@tlendack-t1>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/13 07:34, Tom Lendacky wrote:
> 
> On Tuesday, December 10, 2013 07:21:36 AM Jim Davis wrote:
>> Building with the attached random configuration file,
>>
>> drivers/crypto/ccp/ccp-pci.c: In function ‘ccp_get_msix_irqs’:
>> drivers/crypto/ccp/ccp-pci.c:44:20: error: array type has incomplete
>> element type
>> drivers/crypto/ccp/ccp-pci.c:48:18: error: negative width in bit-field
>> ‘<anonymous>’
>> drivers/crypto/ccp/ccp-pci.c:51:2: error: implicit declaration of
>> function ‘pci_enable_msix’ [-Werror=implicit-function-declaration]
>> drivers/crypto/ccp/ccp-pci.c:76:2: error: implicit declaration of
>> function ‘pci_disable_msix’ [-Werror=implicit-function-declaration]
>> drivers/crypto/ccp/ccp-pci.c:44:20: warning: unused variable
>> ‘msix_entry’ [-Wunused-variable]
>> drivers/crypto/ccp/ccp-pci.c: In function ‘ccp_get_msi_irq’:
>> drivers/crypto/ccp/ccp-pci.c:89:2: error: implicit declaration of
>> function ‘pci_enable_msi’ [-Werror=implicit-function-declaration]
>> drivers/crypto/ccp/ccp-pci.c:102:2: error: implicit declaration of
>> function ‘pci_disable_msi’ [-Werror=implicit-function-declaration]
>> cc1: some warnings being treated as errors
>> make[3]: *** [drivers/crypto/ccp/ccp-pci.o] Error 1
> 
> Thanks for finding this, I'll update to the Kconfig to add PCI to
> the 'depends on' statement.

Tom,

Can you get this patch and the HW_RANDOM patch merged into linux-next, please?
linux-next builds are still failing for both of these reasons.

thanks,
-- 
~Randy
