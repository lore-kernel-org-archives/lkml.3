Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280AbaBRR1K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 12:27:10 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:56589 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbaBRR1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 12:27:08 -0500
X-IronPort-AV: E=Sophos;i="4.97,502,1389772800"; 
   d="scan'208";a="15127804"
Message-ID: <530397D2.3030207@broadcom.com>
Date: Tue, 18 Feb 2014 18:26:42 +0100
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, Denys Vlasenko <dvlasenk@redhat.com>
CC: Franky Lin <frankyl@broadcom.com>, Hante Meuleman <meuleman@broadcom.com>,
        <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c:
 deinline brcmf_sdio_chip_cr4_enterdl, save 440 bytes
References: <1392732320-18973-1-git-send-email-dvlasenk@redhat.com> <1392732925.22752.26.camel@joe-AO722> <53039767.1060907@broadcom.com>
In-Reply-To: <53039767.1060907@broadcom.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2014 06:24 PM, Arend van Spriel wrote:
> On 02/18/2014 03:15 PM, Joe Perches wrote:
>> On Tue, 2014-02-18 at 15:05 +0100, Denys Vlasenko wrote:
>>> Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
>>
>> Hi Denys
>>
>> Perhaps these patch subjects would be better without
>> the file path, but shortened to something like:
>>
>> brcmfmac: sdio_chip: deinline function to reduce object size
> 
> Indeed, only the driver name prefix is nice to have so
> 
> brcmfmac: deinline <func_name> to reduce object size
> 
> Given that you are updating sdio_chip.c makes me conclude that you did
> not make these changes in the wireless-next repository. Can you please
> resubmit them for wireless-next/master.

O, and the patch should be sent to John Linville as he is the wireless
maintainer.

> Regards,
> Arend
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

