Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935407AbaDJJeE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:34:04 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:17618
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934795AbaDJJd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:33:58 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zzbb2dI98dI9371Izz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzdchz1de098h8275bh1de097hz2dh2a8h839h93fhe5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h268bh26b9h26d3h1889i1155h)
Message-ID: <53466573.7050901@freescale.com>
Date: Thu, 10 Apr 2014 17:33:39 +0800
From: Hongbo Zhang <hongbo.zhang@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: David Laight <David.Laight@ACULAB.COM>,
        "vkoul@infradead.org" <vkoul@infradead.org>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>
CC: "scottwood@freescale.com" <scottwood@freescale.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "leo.li@freescale.com" <leo.li@freescale.com>
Subject: Re: [PATCH v3 2/8] DMA: Freescale: unify register access methods
References: <1397113805-24171-1-git-send-email-hongbo.zhang@freescale.com> <1397113805-24171-3-git-send-email-hongbo.zhang@freescale.com> <063D6719AE5E284EB5DD2968C1650D6D0F6F4317@AcuExch.aculab.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D0F6F4317@AcuExch.aculab.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 04/10/2014 04:46 PM, David Laight wrote:
> From: hongbo.zhang@freescale.com
>> Methods of accessing DMA contorller registers are inconsistent, some registers
>                                 ^^

Thanks.
sorry, that it a typo.
I would wait to see if there are other defects I have to correct, if yes 
I can send a new iteration including this update, if no I would like to 
know if the maintainer can do me the favor to correct it when merging 
this patch, if still no, I will send a new iteration for this then.

>> are accessed by DMA_IN/OUT directly, while others are accessed by functions
>> get/set_* which are wrappers of DMA_IN/OUT, and even for the BCR register, it
>> is read by get_bcr but written by DMA_OUT.
>> This patch unifies the inconsistent methods, all registers are accessed by
>> get/set_* now.
> 	David
>



