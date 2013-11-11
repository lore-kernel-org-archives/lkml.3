Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab3KKLTX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 06:19:23 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:43519 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845Ab3KKLTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 06:19:19 -0500
Date: Mon, 11 Nov 2013 11:19:13 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        myungjoo.ham@samsung.com, sameo@linux.intel.com,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] extcon: arizona: Add defines for microphone
 detection levels
Message-ID: <20131111111913.GD22184@lee--X1>
References: <1383916783-17921-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <5280AAAF.8040005@samsung.com>
 <20131111105356.GB22184@lee--X1>
 <5280B836.2050203@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5280B836.2050203@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Nov 2013, Chanwoo Choi wrote:

> On 11/11/2013 07:53 PM, Lee Jones wrote:
> >> On 11/08/2013 10:19 PM, Charles Keepax wrote:
> >>> Improve readability by creating a define for each microphone detection
> >>> level.
> >>>
> >>> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> >>> ---
> >>>  drivers/extcon/extcon-arizona.c       |   21 ++++++++++++++++-----
> >>>  include/linux/mfd/arizona/registers.h |    9 +++++++++
> >>>  2 files changed, 25 insertions(+), 5 deletions(-)
> >>>
> >>> diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
> >>> index 3c55ec8..6d914ba 100644
> >>> --- a/drivers/extcon/extcon-arizona.c
> >>> +++ b/drivers/extcon/extcon-arizona.c
> >>> @@ -44,6 +44,17 @@
> >>>  #define HPDET_DEBOUNCE 500
> >>>  #define DEFAULT_MICD_TIMEOUT 2000
> >>>  
> >>> +enum {
> >>> +	MICD_LVL_1_TO_7 = ARIZONA_MICD_LVL_1 | ARIZONA_MICD_LVL_2 |
> >>> +			  ARIZONA_MICD_LVL_3 | ARIZONA_MICD_LVL_4 |
> >>> +			  ARIZONA_MICD_LVL_5 | ARIZONA_MICD_LVL_6 |
> >>> +			  ARIZONA_MICD_LVL_7,
> >>> +
> >>> +	MICD_LVL_0_TO_7 = ARIZONA_MICD_LVL_0 | MICD_LVL_1_TO_7,
> >>> +
> >>> +	MICD_LVL_0_TO_8 = MICD_LVL_0_TO_7 | ARIZONA_MICD_LVL_8,
> >>> +};
> >>
> >> MICD_LVL_1_TO_7 / MICD_LVL_0_TO_7 /MICD_LVL_0_TO_8 haven't the sequential value.
> >> I prefer '#define' keyword to define MICD_LVL_1_TO_7 / MICD_LVL_0_TO_7 /MICD_LVL_0_TO_8
> >> instead of enum keyword.
> > 
> > Actually Charles has already sent me this patch and I applied it a
> > while ago.
> 
> Why did you applied extcon driver patch on your tree?

Good point, well presented!

I should have just Acked the MFD parts in this case.

It's not too late to pull it back - I'll do just that.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
