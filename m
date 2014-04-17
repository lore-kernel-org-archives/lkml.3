Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412AbaDQRS3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 13:18:29 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:36590 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbaDQRSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 13:18:23 -0400
Message-ID: <53500CDB.8050802@gmail.com>
Date: Thu, 17 Apr 2014 19:18:19 +0200
From: poma <pomidorabelisima@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>
Subject: Re: debug_dma_assert_idle - snd_hda_intel - cpu touching an active
 dma mapped cacheline
References: <534F01D1.9000206@gmail.com> <534F858B.4060208@ladisch.de>
In-Reply-To: <534F858B.4060208@ladisch.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.04.2014 09:40, Clemens Ladisch wrote:
> poma wrote:
>> Sound whispers,
> 
> ???
> 
>>  WARNING: CPU: 3 PID: 900 at lib/dma-debug.c:593 debug_dma_assert_idle+0x159/0x1d0()
>>  snd_hda_intel 0000:00:07.0: DMA-API: cpu touching an active dma mapped cacheline [cln=0x03014000]
>>  ...
>>  Mapped at:
>>   [<c074ec12>] debug_dma_alloc_coherent+0x22/0x70
> 
> "Coherent" means "touching DMA mappings is allowed".
> Why does dma-debug complain about that?
> 
> 
> Regards,
> Clemens
> 

Thanks for comment.
Waiting for rc2 to be sure!


poma


