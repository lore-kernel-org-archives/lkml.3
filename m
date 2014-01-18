Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552AbaARR7X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 12:59:23 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:45917 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbaARR7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 12:59:21 -0500
Message-ID: <52DAC0F1.9080202@landley.net>
Date: Sat, 18 Jan 2014 11:59:13 -0600
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>, hongbo.zhang@freescale.com
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@redhat.com>,
        Richard Henderson <rth@cygnus.com>, Jakub Jelinek <jakub@redhat.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Arthur Kepner <akepner@sgi.com>, sumit.semwal@linaro.org,
        Pierre Ossman <drzeus@drzeus.cx>,
        Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>
Subject: Re: [PATCH resend 1/2] Documentation: move all DMA documentations
 into Documentaion/dma
References: <1389869405-10363-1-git-send-email-hongbo.zhang@freescale.com> <20140116155921.GJ25466@intel.com>
In-Reply-To: <20140116155921.GJ25466@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/14 09:59, Vinod Koul wrote:
> On Thu, Jan 16, 2014 at 06:50:04PM +0800, hongbo.zhang@freescale.com wrote:
>> From: Hongbo Zhang <hongbo.zhang@freescale.com>
>>
>> Since there are already seven DMA documentations under the top Documentation/,
>> it is better to create one dedicated directory for them.
>
> Well the problem is that not everything is same. Some of these mean how to use
> dma mapping API, couple are related to dmaengine, so clubing everything into
> "dma" doesnt sound right to me!

Putting everything in the world in the top level directory isn't all 
flowers and kittens either.

Where would be a _better_ place to move one of those files to?

Rob
