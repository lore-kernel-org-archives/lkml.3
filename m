Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514AbaAPKrb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 05:47:31 -0500
Received: from co1ehsobe005.messaging.microsoft.com ([216.32.180.188]:3995
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751271AbaAPKr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 05:47:28 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VS-5(zzbb2dI98dI9371I936eI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh22d0h2336h2438h2461h2487h1155h)
Message-ID: <52D7B8AB.3070306@freescale.com>
Date: Thu, 16 Jan 2014 18:47:07 +0800
From: Hongbo Zhang <hongbo.zhang@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: <rob@landley.net>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, "David S. Miller" <davem@redhat.com>,
        Richard Henderson <rth@cygnus.com>, Jakub Jelinek <jakub@redhat.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Arthur Kepner <akepner@sgi.com>, <sumit.semwal@linaro.org>,
        Vinod Koul <vinod.koul@intel.com>, Pierre Ossman <drzeus@drzeus.cx>
Subject: Re: [PATCH 1/2] Documentation: move all DMA documentations into Documentaion/dma
References: <1389868664-10202-1-git-send-email-hongbo.zhang@freescale.com> <1389869013.1871.344.camel@smile>
In-Reply-To: <1389869013.1871.344.camel@smile>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Learned, will try, I didn't like this long patch either.
Thanks.


On 01/16/2014 06:43 PM, Andy Shevchenko wrote:
> On Thu, 2014-01-16 at 18:37 +0800, hongbo.zhang@freescale.com wrote:
>> From: Hongbo Zhang <hongbo.zhang@freescale.com>
>>
>> Since there are already seven DMA documentations under the top Documentation/,
>> it is better to create one dedicated directory for them.
>>
> Can you rebuild this with -M -C and resend?
>
> P.S. hint for future is to use -M -C when you rename files.
>



