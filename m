Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967845Ab3HINcP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 09:32:15 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:22597 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967822Ab3HINcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 09:32:11 -0400
X-AuditID: cbfee68e-b7f276d000002279-b0-5204ef5a3595
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>, "'Chris Ball'" <cjb@laptop.org>
Cc: "'Olof Johansson'" <olof@lixom.net>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'James Hogan'" <james.hogan@imgtec.com>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'Abhilash Kesavan'" <a.kesavan@samsung.com>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1373470926-19314-1-git-send-email-dianders@chromium.org>
 <1375825071-20922-1-git-send-email-dianders@chromium.org>
 <1375825071-20922-2-git-send-email-dianders@chromium.org>
In-reply-to: <1375825071-20922-2-git-send-email-dianders@chromium.org>
Subject: RE: [PATCH v4 1/4] mmc: dw_mmc: Invalidate cache of current_speed
 after suspend/resume
Date: Fri, 09 Aug 2013 22:32:10 +0900
Message-id: <001801ce9504$d9976ab0$8cc64010$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6S7T2tqO6E66j4R1CIxv483nNCiwCC8WWQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgleLIzCtJLcpLzFFi42I5/e+ZkW7Ue5Ygg09NGhaP1yxmsngwbxub
	xfbXG9kszi47yGbx6sgPJot3814wW9z41cZqcXnXHDaLI//7GS1OXf/MZrFq1x9GB26P2Q0X
	WTx2zrrL7tGz8wyjx6Eraxk9rpxoYvXo27KK0ePzJrkA9igum5TUnMyy1CJ9uwSujLOrbQse
	iVVM/bSAtYGxTaiLkZNDQsBEYtaXbnYIW0ziwr31bF2MXBxCAssYJfZtXsQKU3TnTyszRGIR
	o0TD1ElMEM4fRonvH0AynBxsAloSf9+8AbNFBLwkXux+ANbBLPCESeLax2uMEB17GSVurr0M
	NpdTwE3iffsbsOXCAokSJ5dcZgSxWQRUJZZ2TwOL8wrYSjRcmscGYQtK/Jh8jwXEZhYwkHg/
	q48VwpaX2LzmLdA2DqBb1SUe/dWFOMJIYunEiVAlIhL7XrxjhHhnKofEkvOcEKsEJL5NPsQC
	0SorsekAM0SJpMTBFTdYJjBKzEKyeBaSxbOQLJ6FZMMCRpZVjKKpBckFxUnpRUZ6xYm5xaV5
	6XrJ+bmbGCGx37eD8eYB60OMyUDrJzJLiSbnA1NHXkm8obGZkYWpiamxkbmlGWnCSuK8ai3W
	gUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoY81ZYaGdv7YlmuhwWfT/7+pkLPP9/lh7MNNjC
	903VbKP0r4V5pjrMi+WSfEo9Sps0L25Yc+Vzo50W7/Xiintt04yS266IPJ9r6CqSd/Z1bsfM
	LQ964g7bX7zIwLeCg2HZ3/vmNQwP26Q2Ngeb2So98tMuerI78vMda6Ytihac5nJpFTa30oyU
	WIozEg21mIuKEwHHQn9WEwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHKsWRmVeSWpSXmKPExsVy+t9jAd2o9yxBBrualS0er1nMZPFg3jY2
	i+2vN7JZnF12kM3i1ZEfTBbv5r1gtrjxq43V4vKuOWwWR/73M1qcuv6ZzWLVrj+MDtwesxsu
	snjsnHWX3aNn5xlGj0NX1jJ6XDnRxOrRt2UVo8fnTXIB7FENjDYZqYkpqUUKqXnJ+SmZeem2
	St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QFcqKZQl5pQChQISi4uV9O0wTQgNcdO1
	gGmM0PUNCYLrMTJAAwnrGDPOrrYteCRWMfXTAtYGxjahLkZODgkBE4k7f1qZIWwxiQv31rN1
	MXJxCAksYpRomDqJCcL5wyjx/QNEFZuAlsTfN2/AbBEBL4kXux8wgxQxCzxhkrj28RojRMde
	Rombay+zglRxCrhJvG9/ww5iCwskSpxccpkRxGYRUJVY2j0NLM4rYCvRcGkeG4QtKPFj8j0W
	EJtZwEDi/aw+VghbXmLzmrdA2ziAblWXePRXF+III4mlEydClYhI7HvxjnECo9AsJJNmIZk0
	C8mkWUhaFjCyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQITi3PpHYwrmywOMQowMGoxMOr
	uJ05SIg1say4MvcQowQHs5II7/YJLEFCvCmJlVWpRfnxRaU5qcWHGJOBHp3ILCWanA9Me3kl
	8YbGJmZGlkZmFkYm5uakCSuJ8x5otQ4UEkhPLEnNTk0tSC2C2cLEwSnVwLg49GrVvldG5iEq
	r2d9bo64I9vP+8wvJSyV62em45wt/3rsC/UCbs4zFZjzhD0yw3/h44nvOwvdHtWelZeZ5xzb
	a7M7aWNzhZlo/7TqyB8HmF4JPdzgufW+0sZzq6WUlB8+MM498sIuPyj6QIbXTi1Nb0aD18JV
	bx9MDpzkmtN/zdhKM3K7gRJLcUaioRZzUXEiAFtsRyZxAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, August 07, 2013, Doug Anderson wrote:
> The dw_mmc driver keeps a cache of the current slot->clock in order to
> avoid doing a whole lot of work every time set_ios() is called.
> However, after suspend/resume the register values are bogus so we need
> to ensure that the cached value is invalidated.
This mismatch comes only in case MMC_PM_KEEP_POWER, right?

> 
> In many cases we got by without this since the core mmc code fiddles
> with the clock a lot.  If we've got a card present we're probably
> running it at something like 50MHz and the core will temporarily
> switch us to 400kHz after resume.  One case that didn't work (for me)
> is the case of having no card in the slot.  The slot is initted to
> 400kHz at boot time.  After suspend/resume the slot thinks it's still
> at 400kHz (due to the cache) so doesn't adjust timing.  When it tries
> to send the command at probe time it just times out and gets left in a
> bad state.
I understand this change although some part of commit message (boot time, probe time...) make me confused.
I guess this change intends to update clock programming forcedly.
It looks like another version of 'dw_mci_setup_bus(slot, true)'.
Eventually, this change does same?

Thanks,
Seungwon Jeon

> 
> Invalidating the current_speed also means that we don't need to call:
>   dw_mci_setup_bus(slot, true);
> ...to force an update of the clock in the case when the slot was left
> powered.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
> Changes in v4: None
> Changes in v3: None
> Changes in v2:
> - Fix typo (some -> come)
> - Use ~0 instead of 0xFFFFFFFF; add comment about value
> 
>  drivers/mmc/host/dw_mmc.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index ee5f167..13a363c 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -2511,13 +2511,19 @@ int dw_mci_resume(struct dw_mci *host)
>  		   DW_MCI_ERROR_FLAGS | SDMMC_INT_CD);
>  	mci_writel(host, CTRL, SDMMC_CTRL_INT_ENABLE);
> 
> +	/*
> +	 * Invalidate the 'current_speed' value since CLKDIV has come up in
> +	 * default state and our cache is incorrect; set to something we know
> +	 * slot->clock won't be.
> +	 */
> +	host->current_speed = ~0;
> +
>  	for (i = 0; i < host->num_slots; i++) {
>  		struct dw_mci_slot *slot = host->slot[i];
>  		if (!slot)
>  			continue;
>  		if (slot->mmc->pm_flags & MMC_PM_KEEP_POWER) {
>  			dw_mci_set_ios(slot->mmc, &slot->mmc->ios);
> -			dw_mci_setup_bus(slot, true);
>  		}
> 
>  		ret = mmc_resume_host(host->slot[i]->mmc);
> --
> 1.8.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

