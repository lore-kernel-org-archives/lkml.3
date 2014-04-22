Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137AbaDVKxI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 06:53:08 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:47099 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755478AbaDVKxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 06:53:04 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-67-53564a0d21c3
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Ulf Hansson'" <ulf.hansson@linaro.org>
Cc: "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
        "'Fariya Fatima'" <fariyaf@gmail.com>,
        "'John W. Linville'" <linville@tuxdriver.com>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'Chris Ball'" <chris@printf.net>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "'linux-mmc'" <linux-mmc@vger.kernel.org>
References: <000c01cf5df8$1fecf810$5fc6e830$%jun@samsung.com>
 <CAPDyKFoMOJ_Eb3O5B-Sy-fF0Yx7Mp==3-Wyff=rTVNCO3YxCFg@mail.gmail.com>
In-reply-to: <CAPDyKFoMOJ_Eb3O5B-Sy-fF0Yx7Mp==3-Wyff=rTVNCO3YxCFg@mail.gmail.com>
Subject: RE: [PATCH] linux-next: rsi: fix using of removed stuff from mmc
Date: Tue, 22 Apr 2014 19:53:00 +0900
Message-id: <000801cf5e19$07613c40$1623b4c0$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9eBOmnbYdrPS68Suegc0gHLm3yzgACZbzg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAIsWRmVeSWpSXmKPExsVy+t8zA11er7Bggw0d8hYTLm9ntGiY9ITV
	4savNlaLy7vmsFkc+d/PaHFwYRujxdYeCYute6+yWxxfG+7A6dF44wabx85Zd9k97lzbw+Zx
	49VCJo++LasYPa58X83o8XmTXAB7FJdNSmpOZllqkb5dAldGwyH5ghWSFVd+LmVrYPws2MXI
	ySEhYCLRvKSZEcIWk7hwbz0biC0ksIxR4tgCT5iajT+2MnUxcgHFpzNK3F/9hRGi6A+jxKYJ
	0SA2m4CWxN83b5hBbBEg+8rOv6wgDcwCO5kkmjbsgJrawigx53INiM0pECyx/9VHsEHCAp4S
	U54fBathEVCVaO3cxwRi8wrYSvQuvQ5lC0r8mHyPpYuRA2iousSUKbkgYWYBeYnNa94yg4Ql
	gMKP/upCnGAk0bbqMhtEiYjEvhfvGEHOkRDo5JA4fvcYM8QqAYlvkw+xQPTKSmw6wAzxr6TE
	wRU3WCYwSsxCsngWwuJZSBbPQrJhASPLKkbR1ILkguKk9CIjveLE3OLSvHS95PzcTYyQ2O7b
	wXjzgPUhxmSg7ROZpUST84GpIa8k3tDYzMjC1MTU2Mjc0ow0YSVx3kUPk4KEBNITS1KzU1ML
	Uovii0pzUosPMTJxcEo1MNovPr1o6m6xdjNHXf2i8x5lOqHMgtn/GEOFJ3md1J4zvWabtmu7
	I39oQ+kSieyuNQfl9n9Yv0zLP/frlw3/0vnisia4B0/Oyo/NvL6cN+pE+4oNc1UmL/837+6L
	jx5BCjxThFZu3WRtILkx9iXb53ccV4ODejJm+P+pjm2Wu3H0TZrX0gmf0pVYijMSDbWYi4oT
	AbLgEY0DAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHKsWRmVeSWpSXmKPExsVy+t9jQV1er7BggyvHJC0mXN7OaNEw6Qmr
	xY1fbawWl3fNYbM48r+f0eLgwjZGi609EhZb915ltzi+NtyB06Pxxg02j52z7rJ73Lm2h83j
	xquFTB59W1Yxelz5vprR4/MmuQD2qAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNL
	C3MlhbzE3FRbJRefAF23zBygy5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCB
	hHWMGQ2H5AtWSFZc+bmUrYHxs2AXIyeHhICJxMYfW5kgbDGJC/fWs3UxcnEICUxnlLi/+gsj
	SEJI4A+jxKYJ0SA2m4CWxN83b5hBbBEg+8rOv6wgDcwCO5kkmjbsYINoaGGUmHO5BsTmFAiW
	2P/qI9ggYQFPiSnPj4LVsAioSrR27gPbzCtgK9G79DqULSjxY/I9li5GDqCh6hJTpuSChJkF
	5CU2r3nLDBKWAAo/+qsLcYKRRNuqy2wQJSIS+168Y5zAKDQLyaBZCINmIRk0C0nHAkaWVYyi
	qQXJBcVJ6bmGesWJucWleel6yfm5mxjBqeOZ1A7GlQ0WhxgFOBiVeHglDEKDhVgTy4orcw8x
	SnAwK4nwsuqGBQvxpiRWVqUW5ccXleakFh9iTAZ6cyKzlGhyPjCt5ZXEGxqbmBlZGplZGJmY
	m5MmrCTOe6DVOlBIID2xJDU7NbUgtQhmCxMHp1QDo57h+bhteiyPTeOnx0duWy50i0Oi6fic
	JcyZDNJsT73+TXN9OUGMw+rs2vTpNYsqIl9VLm56YTz/xI/zs+dNPWMjupSXq1b8woL1ehfP
	yL8oWNM1SSzOfcvF9adVen6sutPjZtqv/Pfn25QnzyLKubzeCz3r/HNVYePLlLJEvXiFO7+V
	TiRYmyuxFGckGmoxFxUnAgBnAxnvYQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, April 22, 2014, Ulf Hansson wrote:
> On 22 April 2014 08:57, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> > As commit 3957848(mmc: drop the speed mode of card's state) applies,
> > this change should be followed.
> >
> > drivers/net/wireless/rsi/rsi_91x_sdio.c:288:20: error: 'MMC_STATE_HIGHSPEED' undeclared (first use
> in this function)
> > drivers/net/wireless/rsi/rsi_91x_sdio.c:299:4: error: implicit declaration of function
> 'mmc_card_set_highspeed' [-Werror=implicit-function-declaration]
> > drivers/net/wireless/rsi/rsi_91x_sdio.c:306:2: error: implicit declaration of function
> 'mmc_card_highspeed' [-Werror=implicit-function-declaration]
> >
> > Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
> 
> Hi Seungwon,
> 
> Thanks for responding quickly!
> 
> > ---
> >  drivers/net/wireless/rsi/rsi_91x_sdio.c |    4 +---
> >  1 files changed, 1 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
> > index 2e39d38..46e7af4 100644
> > --- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
> > +++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
> > @@ -285,7 +285,6 @@ static void rsi_reset_card(struct sdio_func *pfunction)
> >                 if (err) {
> >                         rsi_dbg(ERR_ZONE, "%s: CCCR speed reg read failed: %d\n",
> >                                 __func__, err);
> > -                       card->state &= ~MMC_STATE_HIGHSPEED;
> >                 } else {
> >                         err = rsi_cmd52writebyte(card,
> >                                                  SDIO_CCCR_SPEED,
> > @@ -296,14 +295,13 @@ static void rsi_reset_card(struct sdio_func *pfunction)
> >                                         __func__, err);
> >                                 return;
> >                         }
> > -                       mmc_card_set_highspeed(card);
> >                         host->ios.timing = MMC_TIMING_SD_HS;
> >                         host->ops->set_ios(host, &host->ios);
> >                 }
> >         }
> >
> >         /* Set clock */
> > -       if (mmc_card_highspeed(card))
> > +       if (mmc_card_hs(card))
> >                 clock = 50000000;
> >         else
> >                 clock = card->cis.max_dtr;
> > --
> > 1.7.0.4
> >
> >
> 
> I am not sure it's safe to carry this patch through Chris' mmc tree
> due to merge conflicts with John's wireless tree.
> 
> Though, since you have changed the mmc_card_highspeed() function to be
> named to mmc_card_hs(), we need to work out the dependency.
> 
> We have some options to handle this, I suggest the following.
> 
> Re-spin this patch to keep using mmc_card_highspeed() and let John
> take it through his wireless tree. Thus  you also need to keep the
It would be better if this patch can be handled in Chris's.
Because if the rest of changes of this patch with keeping "mmc_card_highspeed" is applied,
high-speed SDIO will be ignored in John's tree.

Thanks,
Seungwon Jeon

> name mmc_card_highspeed() function from the patches to the mmc core -
> could you please re-spin and post new version of those patches as
> well!?
> 
> Kind regards
> Ulf Hansson

