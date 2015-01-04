Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751213AbbADGVp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 01:21:45 -0500
Received: from mail-oi0-f42.google.com ([209.85.218.42]:40524 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbbADGVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 01:21:43 -0500
Message-ID: <54A8DBF4.4050202@lwfinger.net>
Date: Sun, 04 Jan 2015 00:21:40 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Brett Rudley <brudley@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>
CC: Hante Meuleman <meuleman@broadcom.com>, Kalle Valo <kvalo@adurom.com>,
        Fabian Frederick <fabf@skynet.be>, linux-wireless@vger.kernel.org,
        brcm80211-dev-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] brcm80211: brcmsmac: dma: Remove some unused functions
References: <1420332469-5907-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1420332469-5907-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2015 06:47 PM, Rickard Strandqvist wrote:
> Removes some functions that are not used anywhere:
> dma_txflush() dma_txsuspended()
>
> This was partially found by using a static code analysis program called cppcheck.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>   drivers/net/wireless/brcm80211/brcmsmac/dma.c |   19 -------------------
>   drivers/net/wireless/brcm80211/brcmsmac/dma.h |    2 --
>   2 files changed, 21 deletions(-)

Just because file dma.c is involved, it does not need to be, nor should it be in 
the subject line. You could specify the driver names in the file tree after 
wireless. In this instance, one possible subject would be "brcm80211: brcmsmac: 
Remove some unused functions". On the other hand, if you look at "git log" to 
see past patches, the driver maintainers even leave off the brcm80211 part, thus 
to match them, the subject should be "brcmsmac: Remove some unused functions".

As was suggested earlier, you need to look at the precedents. Keeping a uniform 
method of patch naming helps when looking for patches in the git log.

Larry


