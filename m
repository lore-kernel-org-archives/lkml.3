Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522AbaGVAAg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 20:00:36 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52561 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbaGVAAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 20:00:34 -0400
Message-ID: <53CDA99D.4090602@infradead.org>
Date: Mon, 21 Jul 2014 17:00:29 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Gavin Shan <gwshan@linux.vnet.ibm.com>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI/AER: Forward declare struct pci_dev to avoid warning
References: <1405960243-589-1-git-send-email-ttynkkynen@nvidia.com> <20140721232732.GA4736@shangw>
In-Reply-To: <20140721232732.GA4736@shangw>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2014 04:27 PM, Gavin Shan wrote:
> On Mon, Jul 21, 2014 at 07:30:43PM +0300, Tuomas Tynkkynen wrote:
> 
> I guess it's same issue and fix as:
> 
> http://patchwork.ozlabs.org/patch/370629/

Yes, and it still needs to be merged.... :(

> Thanks,
> Gavin
> 
>> Forward declaring struct pci_dev in aer.h avoids this warning:
>>
>> In file included from include/ras/ras_event.h:11:0,
>>                 from drivers/ras/ras.c:13:
>> include/linux/aer.h:38:44: warning: 'struct pci_dev’ declared inside parameter list [enabled by default]
>> include/linux/aer.h:38:44: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]
>>
>> Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
>> ---
>> include/linux/aer.h | 2 ++
>> 1 file changed, 2 insertions(+)
>>
>> diff --git a/include/linux/aer.h b/include/linux/aer.h
>> index 4dbaa70..d9ec8dd 100644
>> --- a/include/linux/aer.h
>> +++ b/include/linux/aer.h
>> @@ -7,6 +7,8 @@
>> #ifndef _AER_H_
>> #define _AER_H_
>>
>> +struct pci_dev;
>> +
>> #define AER_NONFATAL			0
>> #define AER_FATAL			1
>> #define AER_CORRECTABLE			2
>> -- 


-- 
~Randy
