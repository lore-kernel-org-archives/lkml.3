Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbaFHBly (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 21:41:54 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:61742 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbaFHBlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 21:41:53 -0400
X-CheckPoint: {5393BF60-0-2100090A-C0000000}
Message-ID: <5393BF61.5010306@tilera.com>
Date: Sat, 7 Jun 2014 21:41:53 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch: tile: kernel: unaligned.c:  Cleaning up uninitialized
 variables
References: <1401577213-3673-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1401577213-3673-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [50.189.5.88]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/31/2014 7:00 PM, Rickard Strandqvist wrote:
> There is a risk that the variable will be used without being initialized.
>
> This was largely found by using a static code analysis program called cppcheck.
>
> Signed-off-by: Rickard Strandqvist<rickard_strandqvist@spectrumdigital.se>
> ---
>   arch/tile/kernel/unaligned.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

Thanks!  Taken into the tile tree with some slight modifications (initialize variables to -1 not 0, and remove the resulting dead code in find_regs).

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

