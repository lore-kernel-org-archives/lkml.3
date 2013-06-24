Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab3FXIEg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 04:04:36 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:43395 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961Ab3FXIEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 04:04:32 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-48-51c7fd8abeef
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>, "'Chris Ball'" <cjb@laptop.org>
Cc: "'Olof Johansson'" <olof@lixom.net>,
        "'Andrew Bresticker'" <abrestic@chromium.org>,
        "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'Abhilash Kesavan'" <a.kesavan@samsung.com>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1371772064-7505-1-git-send-email-dianders@chromium.org>
In-reply-to: <1371772064-7505-1-git-send-email-dianders@chromium.org>
Subject: RE: [PATCH] mmc: dw_mmc: don't queue up a card detect at slot startup
Date: Mon, 24 Jun 2013 17:04:25 +0900
Message-id: <001401ce70b1$71c325e0$554971a0$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac5uEKGYZViigKPkRqWY15FdNJN5sQChAfxg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsVy+t8zA92uv8cDDeY2qlk8XrOYyWLl+7+M
	Fg/mbWOz2P56I5vF2WUH2Sxu/Gpjtbi8aw6bxZH//YwWp65/ZrNYtesPowOXx+yGiyweO2fd
	Zfc4dGUto8eVE02sHn1bVjF6fN4kF8AWxWWTkpqTWZZapG+XwJXxfvtz9oKXkhU73u1ibGC8
	JNLFyMkhIWAisfjCe1YIW0ziwr31bF2MXBxCAssYJXbdvscMU3RkXysjRGI6o8SeznOsEM4f
	RonN15cygVSxCWhJ/H3zBqxDRMBL4sXuB8wgRcwCe5kk9v7sASsSEnCR+LJ/ORuIzSngKnHg
	xy12EFtYwE/iy44+sGYWAVWJ9v/rWboYOTh4BWwlNi0sAgnzCghK/Jh8jwXEZhYwkHg/q48V
	wpaX2LzmLTNIuYSAusSjv7oQJxhJzJ77kh2iRERi34t3YA9ICEzkkOh4/JQJYpWAxLfJh1gg
	emUlNh2AelhS4uCKGywTGCVmIdk8C8nmWUg2z0KyYgEjyypG0dSC5ILipPQiE73ixNzi0rx0
	veT83E2MkDifsIPx3gHrQ4zJQOsnMkuJJucD00ReSbyhsZmRhamJqbGRuaUZacJK4rzqLdaB
	QgLpiSWp2ampBalF8UWlOanFhxiZODilGhjr9Q+zdu3sV5CrXOt4TfPz2/Qr7tsuTVolExZi
	3FXJEbzrsI/Us59/P2a+Yt7VJTRVRP5jgLXdkxMr1wglelTwmjc360fPsqpbcc56qsCqtfGV
	jz9J+Xwu/SasOqdpy/d5/55kWoos0yk5YnDWNO+B6Q9boaaaWe8vGy7dIbc939bjn+7iWx5K
	LMUZiYZazEXFiQAuPOSTCQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMKsWRmVeSWpSXmKPExsVy+t9jQd2uv8cDDdbdUrB4vGYxk8XK938Z
	LR7M28Zmsf31RjaLs8sOslnc+NXGanF51xw2iyP/+xktTl3/zGaxatcfRgcuj9kNF1k8ds66
	y+5x6MpaRo8rJ5pYPfq2rGL0+LxJLoAtqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ
	19DSwlxJIS8xN9VWycUnQNctMwfoNiWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1G
	BmggYR1jxvvtz9kLXkpW7Hi3i7GB8ZJIFyMnh4SAicSRfa2MELaYxIV769m6GLk4hASmM0rs
	6TzHCuH8YZTYfH0pE0gVm4CWxN83b5hBbBEBL4kXux8wgxQxC+xlktj7swesSEjAReLL/uVs
	IDangKvEgR+32EFsYQE/iS87+sCaWQRUJdr/r2fpYuTg4BWwldi0sAgkzCsgKPFj8j0WEJtZ
	wEDi/aw+VghbXmLzmrfMIOUSAuoSj/7qQpxgJDF77kt2iBIRiX0v3jFOYBSahWTSLCSTZiGZ
	NAtJywJGllWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwUnkmdQOxpUNFocYBTgYlXh4f1ge
	DxRiTSwrrsw9xCjBwawkwnvoClCINyWxsiq1KD++qDQntfgQYzLQnxOZpUST84EJLq8k3tDY
	xMzI0sjMwsjE3Jw0YSVx3gOt1oFCAumJJanZqakFqUUwW5g4OKUaGKVTlK8pMhiuUqvn5Zmz
	7Df/UpVHGhy7p1/vj9J2sHgoM5n/M9vDywtyY9NazMTeB9q92GGXfudf5aVXrtatK3adKS+I
	ychVW7tdV1WWyaegMflP/D25lMkPG1b9tPJ/vtnz74e92Q++tx6LjovXcJu7spJj8s0o17q0
	j+1ihskab858SuQPVGIpzkg01GIuKk4EAL6MfhVmAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, June 21 2013, Doug Anderson wrote:
> The MMC subsystem handles looking for a card at probe time.  Queuing
> up our own can race with the rest of the MMC subsystem and cause
> problems if we get unlucky with timing.  Just remove our own
> detection.
This patch looks good to me. I agree above.
Card detection procedure of mmc subsystem will be started by mmc_start_host during probe time.
There is no need to do same in host driver.
Could you describe the race point of this problem and why the duplication makes the problem?
What is described below is not clear.
If a actual detection of card is triggered during probe, similar problem may be occurred in spite of this patch.

Thanks,
Seungwon Jeon
> 
> Specifically, I found that with just the right set of printouts in my
> system that one of the three SD/MMC devices in my system was having
> trouble probing.  It would get an err -123 (-ENOMEDIUM) during probe.
> I found that the source of the error was in
> dw_mci_work_routine_card().  Adding more printouts to the code
> sometimes made this error go away, so it's a little touchy.
> 
> You can see a snippet with my printouts in it (printouts were in
> set_ios() on an exynos5420 board with some of our local patches):
> 
> [    4.216595] dwmmc_exynos 12210000.dwmmc1: Using internal DMA controller.
> [    4.395935] dwmmc_exynos 12210000.dwmmc1: Version ID is 250a
> [    4.401948] dwmmc_exynos 12210000.dwmmc1: DW MMC controller at irq 108, 64 bit host data width, 64
> deep fifo
> [    4.424430] dwmmc_exynos 12210000.dwmmc1: sdr0 mode (irq=108, width=0)
> [    4.453975] dwmmc_exynos 12210000.dwmmc1: sdr0 mode (irq=108, width=0)
> [    4.459592] mmc_host mmc1: Bus speed (slot 0) = 100000000Hz (slot req 400000Hz, actual 400000HZ div
> = 125)
> [    4.484258] dwmmc_exynos 12210000.dwmmc1: 1 slots initialized
> [    4.485406] dwmmc_exynos 12210000.dwmmc1: sdr0 mode (irq=108, width=0)
> [    4.487606] dwmmc_exynos 12210000.dwmmc1: sdr0 mode (irq=108, width=0)
> [    4.489794] dwmmc_exynos 12210000.dwmmc1: sdr0 mode (irq=108, width=0)
> [    4.509757] mmc1: error -123 whilst initialising SDIO card
> 
> While digging I found that doing our own card detection at init time
> didn't appear to be necessary.  If I remove this code then cards that
> are in the system at bootup are still detected just fine.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  drivers/mmc/host/dw_mmc.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index bc3a1bc..c3a6fe9 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -2016,12 +2016,6 @@ static int dw_mci_init_slot(struct dw_mci *host, unsigned int id)
>  	/* Card initially undetected */
>  	slot->last_detect_state = 0;
> 
> -	/*
> -	 * Card may have been plugged in prior to boot so we
> -	 * need to run the detect tasklet
> -	 */
> -	queue_work(host->card_workqueue, &host->card_work);
> -
>  	return 0;
> 
>  err_setup_bus:
> --
> 1.8.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

