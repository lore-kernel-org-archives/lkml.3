Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759177Ab3AQGsg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 01:48:36 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:11621 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758848Ab3AQGsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 01:48:33 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-87-50f79ebf7077
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Ulf Hansson'" <ulf.hansson@linaro.org>,
        "'Maya Erez'" <merez@codeaurora.org>
Cc: "'Subhash Jadavani'" <subhashj@codeaurora.org>, linux-mmc@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        "'open list'" <linux-kernel@vger.kernel.org>
References: <1357936936-25977-1-git-send-email-merez@codeaurora.org>
 <50F10B86.6020905@codeaurora.org>
 <002701cdf1d7$99dd1d00$cd975700$@codeaurora.org>
 <CAPDyKFrjFhBMHqn+CYB5LPwiWmAOWmiL2pm5Kww5u9jUrQ4p3w@mail.gmail.com>
In-reply-to: <CAPDyKFrjFhBMHqn+CYB5LPwiWmAOWmiL2pm5Kww5u9jUrQ4p3w@mail.gmail.com>
Subject: RE: [PATCH] mmc: core: disable the cache before suspend only after
 stopping BKOPS
Date: Thu, 17 Jan 2013 15:48:30 +0900
Message-id: <000701cdf47e$a97c3a80$fc74af80$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=Windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac30McBFldRPy+wDR4KNEP8L8xEG5wAS7a5w
Content-language: ko
x-cr-hashedpuzzle: Gcza L3VY L4+Z NISF Qn4U RC6r YnsF fMWB tztE u32G vpwg xL6Z
 ykZP y6yt zGo5
 zao+;6;bABpAG4AdQB4AC0AYQByAG0ALQBtAHMAbQBAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AGwAaQBuAHUAeAAtAG0AbQBjAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBtAGUAcgBlAHoAQABjAG8AZABlAGEAdQByAG8AcgBhAC4AbwByAGcAOwBzAHUAYgBoAGEAcwBoAGoAQABjAG8AZABlAGEAdQByAG8AcgBhAC4AbwByAGcAOwB1AGwAZgAuAGgAYQBuAHMAcwBvAG4AQABsAGkAbgBhAHIAbwAuAG8AcgBnAA==;Sosha1_v1;7;{69BA2ACF-3D2B-434C-93D3-061B6F8019AF};dABnAGkAaAAuAGoAdQBuAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtAA==;Thu,
 17 Jan 2013 06:48:21
 GMT;UgBFADoAIABbAFAAQQBUAEMASABdACAAbQBtAGMAOgAgAGMAbwByAGUAOgAgAGQAaQBzAGEAYgBsAGUAIAB0AGgAZQAgAGMAYQBjAGgAZQAgAGIAZQBmAG8AcgBlACAAcwB1AHMAcABlAG4AZAAgAG8AbgBsAHkAIABhAGYAdABlAHIAIABzAHQAbwBwAHAAaQBuAGcAIABCAEsATwBQAFMA
x-cr-puzzleid: {69BA2ACF-3D2B-434C-93D3-061B6F8019AF}
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsVy+t8zI939874HGMx5IWkxcf9ZdovLu+aw
	WRz538/owOzxeZNcAGMUl01Kak5mWWqRvl0CV8bD66tYCro0Km4t+crewLhcrouRk0NCwETi
	0LWJLBC2mMSFe+vZuhi5OIQEljFKbJq9gBGm6PiZR4wQiUWMElMvzoJy/jBK7D78EqydTUBL
	4u+bN8xdjBwcIgJ+EodvuoLUMAvMYJS4MncFC0TDI0aJk1+bmEAaOAWCJeY+7GYGsYUFYiR2
	9r1nBbFZBFQlns/uZAcZxCtgK3H6QBBImFdAUOLH5Htgu5gF9CQ+/rnNCGHLS2xe8xZsr4SA
	usSjv7oQJxhJ3LrjB1EhIrHvxTuwkyUEXrBJPP33CuoxU4mtx44zQ2wVkPg2+RALxBhZiU0H
	mCHqL7FLdK47ygZRLylxcMUNlgmMUrOQXDQLyUWzkFw0C8nuBYwsqxhFUwuSC4qT0nMN9YoT
	c4tL89L1kvNzNzFC4lNqB+PKBotDjAIcjEo8vIaXvwUIsSaWFVfmHmKU4GBWEuEtmfE9QIg3
	JbGyKrUoP76oNCe1+BCjD9DlE5mlRJPzgakjryTe0NjYxMzE1MTc0tTcFIewkjgv46knAUIC
	6YklqdmpqQWpRTDjmDg4pRoYzU4+EPkno36wckXS0YOROi/3mmifTb5SKX6rU8SX0U5ba7P6
	42PvE5ytixeETHz7W75FbLaCmnRtrYzo1ri9VxZK2H27bZ32/8/HI7peP5+djk1qM0lp2rJG
	wlHQuX+PkE5Vw+3Na/0jmA1mP1q9Y8faglPNGw+JJtTGNu99qPw7li9xx5cOJZbijERDLeai
	4kQAJWAP/PwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBKsWRmVeSWpSXmKPExsVy+t9jAd39874HGNy7LGIxcf9ZdovLu+aw
	WRz538/owOzxeZNcAGNUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJu
	qq2Si0+ArltmDtB8JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhHWPGw+ur
	WAq6NCpuLfnK3sC4XK6LkZNDQsBE4viZR4wQtpjEhXvr2boYuTiEBBYxSky9OIsRwvnDKLH7
	8EsWkCo2AS2Jv2/eMHcxcnCICPhJHL7pClLDLDCDUeLK3BUsEA2PGCVOfm1iAmngFAiWmPuw
	mxnEFhaIkdjZ954VxGYRUJV4PruTHWQQr4CtxOkDQSBhXgFBiR+T74HtYhbQk/j45zYjhC0v
	sXnNW7C9EgLqEo/+6kKcYCRx644fRIWIxL4X78BOlhB4wSbx9N8rqMdMJbYeO848gVFkFpIN
	s5BsmIVkwywksxYwsqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECI7+Z1I7GFc2WBxiFOBg
	VOLhNbz8LUCINbGsuDL3EKMEB7OSCG/JjO8BQrwpiZVVqUX58UWlOanFhxh9gP6fyCwlmpwP
	TEx5JfGGxiZmRpZGZhZGJubmOISVxHkZTz0JEBJITyxJzU5NLUgtghnHxMEp1cC4dxJHopLI
	iufnil1Lb3bxLkpZf5V/NdMLMRt+W+kfLXx+L2d12q6Te32N6TGbxNt/JgxfS2qaI5fwOD0t
	1DZNm6/z+nKFslBC+pkdO/2rXf5Pqj+pPdNTyPNf9a3DOpX5W3h2C+/1e1ew9r+u/ozCuP7T
	LzYbb3WZrzcruaJ8P9PNpQfaVj1QYinOSDTUYi4qTgQA24xCISsDAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 17, 2013 , Ulf Hansson wrote:
> On 13 January 2013 22:47, Maya Erez <merez@codeaurora.org> wrote:
> > -----Original Message-----
> > From: Subhash Jadavani [mailto:subhashj@codeaurora.org]
> > Sent: Saturday, January 12, 2013 9:07 AM
> > To: Maya Erez
> > Cc: linux-mmc@vger.kernel.org; linux-arm-msm@vger.kernel.org; open list
> > Subject: Re: [PATCH] mmc: core: disable the cache before suspend only after
> > stopping BKOPS
> >
> > On 1/12/2013 2:12 AM, Maya Erez wrote:
> >> mmc_cache_ctrl was called in runtime suspend before MMC interrupted
> >> BKOPS in case it is still running on the card. This caused the cache
> >> disable to timeout.
> > I guess even if the idle time bkops polling is not implemented, this patch
> > is good to have. cache control is the eMMC feature and in that sense, it
> > should have been part of MMC's bus resume (mmc_resume) rather than generic
> > mmc_suspend_host().
> >
> > Patch as such is fine and if you agree, you may want to remove the
> > mentioning of bkops as part of commit text and may just want to mention
> > above reason as the main motivation for this patch.
> >
> > Agreed, I will change the commit text in the next uploaded version.
> >
> >> Therefore, mmc_cache_ctrl has to move to mmc_suspend where we are sure
> >> that the card can go into suspend and there is no pending activity.
> >>
> >> Signed-off-by: Maya Erez <merez@codeaurora.org>
> >> ---
> >>   drivers/mmc/core/core.c |    7 +------
> >>   drivers/mmc/core/mmc.c  |    8 +++++++-
> >>   2 files changed, 8 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c index
> >> aaed768..b438bb2 100644
> >> --- a/drivers/mmc/core/core.c
> >> +++ b/drivers/mmc/core/core.c
> >> @@ -2388,6 +2388,7 @@ EXPORT_SYMBOL(mmc_flush_cache);
> >>    * Turn the cache ON/OFF.
> >>    * Turning the cache OFF shall trigger flushing of the data
> >>    * to the non-volatile storage.
> >> + * This function should be called with host claimed
> >>    */
> >>   int mmc_cache_ctrl(struct mmc_host *host, u8 enable)
> >>   {
> >> @@ -2399,7 +2400,6 @@ int mmc_cache_ctrl(struct mmc_host *host, u8 enable)
> >>                       mmc_card_is_removable(host))
> >>               return err;
> >>
> >> -     mmc_claim_host(host);
> >>       if (card && mmc_card_mmc(card) &&
> >>                       (card->ext_csd.cache_size > 0)) {
> >>               enable = !!enable;
> >> @@ -2417,7 +2417,6 @@ int mmc_cache_ctrl(struct mmc_host *host, u8 enable)
> >>                               card->ext_csd.cache_ctrl = enable;
> >>               }
> >>       }
> >> -     mmc_release_host(host);
> >>
> >>       return err;
> >>   }
> >> @@ -2436,10 +2435,6 @@ int mmc_suspend_host(struct mmc_host *host)
> >>       cancel_delayed_work(&host->detect);
> >>       mmc_flush_scheduled_work();
> >>
> >> -     err = mmc_cache_ctrl(host, 0);
> >> -     if (err)
> >> -             goto out;
> >> -
> >>       mmc_bus_get(host);
> >>       if (host->bus_ops && !host->bus_dead) {
> >>               if (host->bus_ops->suspend) {
> >> diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c index
> >> e6e3911..dc17d40 100644
> >> --- a/drivers/mmc/core/mmc.c
> >> +++ b/drivers/mmc/core/mmc.c
> >> @@ -1379,6 +1379,11 @@ static int mmc_suspend(struct mmc_host *host)
> >>       BUG_ON(!host->card);
> >>
> >>       mmc_claim_host(host);
> >> +
> >> +     err = mmc_cache_ctrl(host, 0);
> >> +     if (err)
> >> +             goto out;
> >> +
> >>       if (mmc_can_poweroff_notify(host->card))
> >>               err = mmc_poweroff_notify(host->card,
> > EXT_CSD_POWER_OFF_SHORT);
> >>       else if (mmc_card_can_sleep(host))
> >> @@ -1386,8 +1391,9 @@ static int mmc_suspend(struct mmc_host *host)
> >>       else if (!mmc_host_is_spi(host))
> >>               err = mmc_deselect_cards(host);
> >>       host->card->state &= ~(MMC_STATE_HIGHSPEED |
> > MMC_STATE_HIGHSPEED_200);
> >> -     mmc_release_host(host);
> >>
> >> +out:
> >> +     mmc_release_host(host);
> >>       return err;
> >>   }
> >>
> > --
> > QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
> > of Code Aurora Forum, hosted by The Linux Foundation
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> I agree that some update to the commit msg is wanted; since this fixup
> is not related to runtime suspend as such.
> Anyway, you have my ack!
> 
> Acked-by: Ulf Hansson <ulf.hansson@linaro.org>

Yes, it's reasonable.
Cache feature is closely connected with eMMC.

Acked-by: Seungwon Jeon <tgin.jun@samsung.com>

Thanks,
Seungwon Jeon
> 
> Kind regards
> Ulf Hansson
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

