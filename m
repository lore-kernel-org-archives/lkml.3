Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751312AbaDQHlF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 03:41:05 -0400
Received: from dehamd003.servertools24.de ([31.47.254.18]:59745 "EHLO
	dehamd003.servertools24.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750852AbaDQHlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 03:41:04 -0400
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
Message-ID: <534F858B.4060208@ladisch.de>
Date: Thu, 17 Apr 2014 09:40:59 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: poma <pomidorabelisima@gmail.com>, Takashi Iwai <tiwai@suse.de>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>
Subject: Re: debug_dma_assert_idle - snd_hda_intel - cpu touching an active
 dma mapped cacheline
References: <534F01D1.9000206@gmail.com>
In-Reply-To: <534F01D1.9000206@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

poma wrote:
> Sound whispers,

???

>  WARNING: CPU: 3 PID: 900 at lib/dma-debug.c:593 debug_dma_assert_idle+0x159/0x1d0()
>  snd_hda_intel 0000:00:07.0: DMA-API: cpu touching an active dma mapped cacheline [cln=0x03014000]
>  ...
>  Mapped at:
>   [<c074ec12>] debug_dma_alloc_coherent+0x22/0x70

"Coherent" means "touching DMA mappings is allowed".
Why does dma-debug complain about that?


Regards,
Clemens
