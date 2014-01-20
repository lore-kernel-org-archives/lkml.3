Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943AbaATJNT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 04:13:19 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:41420
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750942AbaATJNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 04:13:16 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VS-5(z579ehzbb2dI98dI9371I146fI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh22d0h2336h2438h2461h2487h24ach1155h)
Message-ID: <52DCE88C.1070504@freescale.com>
Date: Mon, 20 Jan 2014 17:12:44 +0800
From: Hongbo Zhang <hongbo.zhang@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@redhat.com>,
        Richard Henderson <rth@cygnus.com>, Jakub Jelinek <jakub@redhat.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Arthur Kepner <akepner@sgi.com>, <sumit.semwal@linaro.org>,
        Pierre Ossman <drzeus@drzeus.cx>,
        Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>
Subject: Re: [PATCH resend 1/2] Documentation: move all DMA documentations
 into Documentaion/dma
References: <1389869405-10363-1-git-send-email-hongbo.zhang@freescale.com> <20140116155921.GJ25466@intel.com> <52DAC0F1.9080202@landley.net> <20140120042909.GA26823@intel.com>
In-Reply-To: <20140120042909.GA26823@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 01/20/2014 12:29 PM, Vinod Koul wrote:
> On Sat, Jan 18, 2014 at 11:59:13AM -0600, Rob Landley wrote:
>> On 01/16/14 09:59, Vinod Koul wrote:
>>> On Thu, Jan 16, 2014 at 06:50:04PM +0800, hongbo.zhang@freescale.com wrote:
>>>> From: Hongbo Zhang <hongbo.zhang@freescale.com>
>>>>
>>>> Since there are already seven DMA documentations under the top Documentation/,
>>>> it is better to create one dedicated directory for them.
>>> Well the problem is that not everything is same. Some of these mean how to use
>>> dma mapping API, couple are related to dmaengine, so clubing everything into
>>> "dma" doesnt sound right to me!
>> Putting everything in the world in the top level directory isn't all
>> flowers and kittens either.
>>
>> Where would be a _better_ place to move one of those files to?
> As pointed mostly things dma* are dma-mapping and dmaengine, so would apt
> that we move to two folders, unless i overlooked and assumed everything else is
> dma-mapping!

Understand your concern, dma-mapping and dmaengine are different, but 
they are all about dma, a general dma folder can include all dma related 
files. An example is Documentation/power, so many kinds of power related 
files go there.
Anyway, this is my point, it is up to you maintainers.

> --
> ~Vinod
>
>



