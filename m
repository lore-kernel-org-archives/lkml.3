Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759309Ab3E3THq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 15:07:46 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:35508 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751278Ab3E3THl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 15:07:41 -0400
Message-ID: <51A7A436.5040208@metafoo.de>
Date: Thu, 30 May 2013 21:10:46 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@linux.intel.com>
CC: linux kernel <linux-kernel@vger.kernel.org>, vinod.koul@intel.com
Subject: Re: [alsa-devel] [PATCH 1/2] dma: Add a PAUSE_RESUME capability
References: <1369827743-5533-1-git-send-email-lars@metafoo.de> <1369932575.3890.18.camel@vkoul-udesk3>
In-Reply-To: <1369932575.3890.18.camel@vkoul-udesk3>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2013 06:49 PM, Vinod Koul wrote:
> On Wed, 2013-05-29 at 13:42 +0200, Lars-Peter Clausen wrote:
>> Add a capability which allows dmaengine consumers to query whether a dmaengine
>> controller supports the DMA_PAUSE and DMA_RESUME commands. Sometimes a user of
>> the dmaengine API needs to know in advance if a channel will support
>> pause/resume. E.g. in ALSA the information whether it is possible to
>> pause/resume a audio stream or whether it is necessary to abort and restart the
>> stream is communicated to userspace so it can act accordingly.
> - This mail-list is not correct for this patch
> - use get_maintainer.pl, if you dont know but you already know!
> - always CC maintainers

Hm, I have no idea what happened with the Cc list. I might have hit the up key
one time to many after --dry-run, since this is the Cc list of a different
patch series.

> 
> the enum dma_transaction_type reports what kind of transactions DMA
> controller is capable of. This is not for capabilities of a given
> transaction type, so this approach is not right.

hm, ok.
> 
> Unfortunately, this is not supported by dmaengine atm. We had discussed
> this in last plumbers, and discussion with Matt was to add capability
> API (at least for slave usages). The work from Matt had reached a good
> point but unfortunately didn't reach its conclusion. [1]
> 
> Let me resurrect those patches and add the pause, resume query to it in
> more generic way

I've pinged Matt about these patches yesterday or so. He has been rather quite
lately, maybe he's been sucked into the Linaro blackhole.

- Lars

