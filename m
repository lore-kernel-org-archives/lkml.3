Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932568AbaDVMcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 08:32:19 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:9320 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932419AbaDVMcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 08:32:11 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-20-535661496c87
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
 <000801cf5e19$07613c40$1623b4c0$%jun@samsung.com>
 <CAPDyKFpe4_3BXFB8jxHhZknfmT2UrO6ddCcOpq2whN3ayEO6Dg@mail.gmail.com>
In-reply-to: <CAPDyKFpe4_3BXFB8jxHhZknfmT2UrO6ddCcOpq2whN3ayEO6Dg@mail.gmail.com>
Subject: RE: [PATCH] linux-next: rsi: fix using of removed stuff from mmc
Date: Tue, 22 Apr 2014 21:32:09 +0900
Message-id: <000901cf5e26$e1005fa0$a3011ee0$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9eHxEL3nzv6wmASH6gWTc+LoqzoAABmVaw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsVy+t8zQ13PxLBggzXzVC0mXN7OaNEw6Qmr
	xY1fbawWl3fNYbM48r+f0eLgwjZGi609EhZb915ltzi+NtyB06Pxxg02j52z7rJ73Lm2h83j
	xquFTB59W1Yxelz5vprR4/MmuQD2KC6blNSczLLUIn27BK6M2x+vMhUsUKm4dPcmWwPjRqku
	Rk4OCQETib/L+pkgbDGJC/fWs3UxcnEICSxjlGh9dp8dpmjCgXXsEIlFjBIf/19ngnD+MEr0
	rV7EBlLFJqAl8ffNG2YQWwTIvrLzLytIEbPATiaJpg07wIqEBP4zStzYpAVicwoES5xYcQps
	t7CAp8SU50fBalgEVCUutjWAxXkFbCU+nzsFZQtK/Jh8j6WLkQNoqLrElCm5IGFmAXmJzWve
	MoOEJYDCj/7qQpxgJPFoyR8miBIRiX0v3jGCnCMh0MkhseDVTiaIVQIS3yYfYoHolZXYdIAZ
	4mFJiYMrbrBMYJSYhWTxLITFs5AsnoVkwwJGllWMoqkFyQXFSelFRnrFibnFpXnpesn5uZsY
	IRHet4Px5gHrQ4zJQNsnMkuJJucDE0ReSbyhsZmRhamJqbGRuaUZacJK4ryLHiYFCQmkJ5ak
	ZqemFqQWxReV5qQWH2Jk4uCUamBsftbjGWIzM03GNeJ52GzGfEu+/J1Pu/1+X+SV0XsQmR2h
	uWxLLFf8tPywtcKFpW1TJqi+nj1DjnuT+4zDzz7P0y/V9OMJT3Xeun3+fpXv940XzNqvnrCy
	VWXD/s7Y9kef/Nba2JmE14ve7b9x+rnNwvVewpkiS49M01vEstONfd0sdnlN0VolluKMREMt
	5qLiRAD2Cd/YBgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAKsWRmVeSWpSXmKPExsVy+t9jAV3PxLBgg+8/5S0mXN7OaNEw6Qmr
	xY1fbawWl3fNYbM48r+f0eLgwjZGi609EhZb915ltzi+NtyB06Pxxg02j52z7rJ73Lm2h83j
	xquFTB59W1Yxelz5vprR4/MmuQD2qAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNL
	C3MlhbzE3FRbJRefAF23zBygy5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCB
	hHWMGbc/XmUqWKBScenuTbYGxo1SXYycHBICJhITDqxjh7DFJC7cW8/WxcjFISSwiFHi4//r
	TBDOH0aJvtWL2ECq2AS0JP6+ecMMYosA2Vd2/mUFKWIW2Mkk0bRhB1iRkMB/Rokbm7RAbE6B
	YIkTK04xgdjCAp4SU54fBathEVCVuNjWABbnFbCV+HzuFJQtKPFj8j2WLkYOoKHqElOm5IKE
	mQXkJTavecsMEpYACj/6qwtxgpHEoyV/mCBKRCT2vXjHOIFRaBaSQbMQBs1CMmgWko4FjCyr
	GEVTC5ILipPSc430ihNzi0vz0vWS83M3MYLTxzPpHYyrGiwOMQpwMCrx8EoYhAYLsSaWFVfm
	HmKU4GBWEuF9FREWLMSbklhZlVqUH19UmpNafIgxGejNicxSosn5wNSWVxJvaGxiZmRpZGZh
	ZGJuTpqwkjjvwVbrQCGB9MSS1OzU1ILUIpgtTBycUg2M7WftJF/cLN/aY3xRaONrw5jO7Mri
	edtqT/oYR+e8LhWdefe9vxDDv11sydo/LjhMnH1xc1Vc1323xldMibINvan9fB+eBse6xB9c
	em/tZGbzuf+vTXjapO1ywFiQR/TgAfNgh5sZAoJbnO7HBy/V2/8ss8MiPHHCJ6n9rnF7Zs1Q
	XWJ5tYZdiaU4I9FQi7moOBEAPNx5MWMDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, April 22, 2014, Ulf Hansson wrote:
> On 22 April 2014 12:53, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> > On Tue, April 22, 2014, Ulf Hansson wrote:
> >> On 22 April 2014 08:57, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> >> > As commit 3957848(mmc: drop the speed mode of card's state) applies,
> >> > this change should be followed.
> >> >
> >> > drivers/net/wireless/rsi/rsi_91x_sdio.c:288:20: error: 'MMC_STATE_HIGHSPEED' undeclared (first
> use
> >> in this function)
> >> > drivers/net/wireless/rsi/rsi_91x_sdio.c:299:4: error: implicit declaration of function
> >> 'mmc_card_set_highspeed' [-Werror=implicit-function-declaration]
> >> > drivers/net/wireless/rsi/rsi_91x_sdio.c:306:2: error: implicit declaration of function
> >> 'mmc_card_highspeed' [-Werror=implicit-function-declaration]
> >> >
> >> > Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
> >>
> >> Hi Seungwon,
> >>
> >> Thanks for responding quickly!
> >>
> >> > ---
> >> >  drivers/net/wireless/rsi/rsi_91x_sdio.c |    4 +---
> >> >  1 files changed, 1 insertions(+), 3 deletions(-)
> >> >
> >> > diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
> >> > index 2e39d38..46e7af4 100644
> >> > --- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
> >> > +++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
> >> > @@ -285,7 +285,6 @@ static void rsi_reset_card(struct sdio_func *pfunction)
> >> >                 if (err) {
> >> >                         rsi_dbg(ERR_ZONE, "%s: CCCR speed reg read failed: %d\n",
> >> >                                 __func__, err);
> >> > -                       card->state &= ~MMC_STATE_HIGHSPEED;
> >> >                 } else {
> >> >                         err = rsi_cmd52writebyte(card,
> >> >                                                  SDIO_CCCR_SPEED,
> >> > @@ -296,14 +295,13 @@ static void rsi_reset_card(struct sdio_func *pfunction)
> >> >                                         __func__, err);
> >> >                                 return;
> >> >                         }
> >> > -                       mmc_card_set_highspeed(card);
> >> >                         host->ios.timing = MMC_TIMING_SD_HS;
> >> >                         host->ops->set_ios(host, &host->ios);
> >> >                 }
> >> >         }
> >> >
> >> >         /* Set clock */
> >> > -       if (mmc_card_highspeed(card))
> >> > +       if (mmc_card_hs(card))
> >> >                 clock = 50000000;
> >> >         else
> >> >                 clock = card->cis.max_dtr;
> >> > --
> >> > 1.7.0.4
> >> >
> >> >
> >>
> >> I am not sure it's safe to carry this patch through Chris' mmc tree
> >> due to merge conflicts with John's wireless tree.
> >>
> >> Though, since you have changed the mmc_card_highspeed() function to be
> >> named to mmc_card_hs(), we need to work out the dependency.
> >>
> >> We have some options to handle this, I suggest the following.
> >>
> >> Re-spin this patch to keep using mmc_card_highspeed() and let John
> >> take it through his wireless tree. Thus  you also need to keep the
> > It would be better if this patch can be handled in Chris's.
> > Because if the rest of changes of this patch with keeping "mmc_card_highspeed" is applied,
> > high-speed SDIO will be ignored in John's tree.
> 
> You are right Seungwon!
> 
> Please re-spin the patchset on the mmc core an squash the code from
> this patch, into the patch "mmc: drop the speed mode of card's state".
> We then need to get acks from John and Fariya.
Sure! I'll send before long.
You still want to get back naming for mmc_card_highspeed?

> 
> BTW, I had a look at the rsi_reset_card() function
> (drivers/net/wireless/rsi/rsi_91x_sdio.c), which handles a complete
> SDIO re-initialization and I think performs "layering violations"
> while doing that.  I suppose it's because of lack of documentation
> about the mmc/sdio core, but I really don't think an SDIO func driver
> should be doing that kind of stuff by itself. There are APIs to use to
> perform an SDIO reset. Two options exists:
> 
> a) Use pm_runtime_get|put in combination with a MMC_CAP_POWER_OFF_CARD
> enabled host.
> b) Invoke mmc_power_save|restore_host() API.
Yes, we could expect better changes in rsi sdio soon.

Thanks,
Seungwon Jeon
> 
> Kind regards
> Ulf Hansson
> 
> >
> > Thanks,
> > Seungwon Jeon
> >
> >> name mmc_card_highspeed() function from the patches to the mmc core -
> >> could you please re-spin and post new version of those patches as
> >> well!?
> >>
> >> Kind regards
> >> Ulf Hansson
> >

