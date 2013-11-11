Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab3KKLPQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 06:15:16 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:40336 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab3KKLPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 06:15:10 -0500
Date: Mon, 11 Nov 2013 11:15:03 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, myungjoo.ham@samsung.com,
        sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] extcon: arizona: Add defines for microphone
 detection levels
Message-ID: <20131111111503.GC22184@lee--X1>
References: <1383916783-17921-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <5280AAAF.8040005@samsung.com>
 <20131111105356.GB22184@lee--X1>
 <20131111110652.GD6549@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131111110652.GD6549@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Nov 2013, Charles Keepax wrote:

> On Mon, Nov 11, 2013 at 10:53:56AM +0000, Lee Jones wrote:
> > > On 11/08/2013 10:19 PM, Charles Keepax wrote:
> > > > Improve readability by creating a define for each microphone detection
> > > > level.
> > > > 
> > > > Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> > > > ---
> > > >  drivers/extcon/extcon-arizona.c       |   21 ++++++++++++++++-----
> > > >  include/linux/mfd/arizona/registers.h |    9 +++++++++
> > > >  2 files changed, 25 insertions(+), 5 deletions(-)
> > > > 
> > > > diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
> > > > index 3c55ec8..6d914ba 100644
> > > > --- a/drivers/extcon/extcon-arizona.c
> > > > +++ b/drivers/extcon/extcon-arizona.c
> > > > @@ -44,6 +44,17 @@
> > > >  #define HPDET_DEBOUNCE 500
> > > >  #define DEFAULT_MICD_TIMEOUT 2000
> > > >  
> > > > +enum {
> > > > +	MICD_LVL_1_TO_7 = ARIZONA_MICD_LVL_1 | ARIZONA_MICD_LVL_2 |
> > > > +			  ARIZONA_MICD_LVL_3 | ARIZONA_MICD_LVL_4 |
> > > > +			  ARIZONA_MICD_LVL_5 | ARIZONA_MICD_LVL_6 |
> > > > +			  ARIZONA_MICD_LVL_7,
> > > > +
> > > > +	MICD_LVL_0_TO_7 = ARIZONA_MICD_LVL_0 | MICD_LVL_1_TO_7,
> > > > +
> > > > +	MICD_LVL_0_TO_8 = MICD_LVL_0_TO_7 | ARIZONA_MICD_LVL_8,
> > > > +};
> > > 
> > > MICD_LVL_1_TO_7 / MICD_LVL_0_TO_7 /MICD_LVL_0_TO_8 haven't the sequential value.
> > > I prefer '#define' keyword to define MICD_LVL_1_TO_7 / MICD_LVL_0_TO_7 /MICD_LVL_0_TO_8
> > > instead of enum keyword.
> 
> 
> I will do an incremental patch to update them to defines.
> 
> 
> > Actually Charles has already sent me this patch and I applied it a
> > while ago.
> > 
> > I'm inclined to agree with you though, so if you want to send a patch
> > based on v3.14-rc1 I'd be happy to accept it.
> 
> Apologies for causing confusion here I checked your tree for the
> patch and didn't see it, so I assumed you had decided not to
> apply it. I must have missed it some how.

So I am partly to blame here. My public repos sometimes aren't as
up-to-date and my private ones, but if I've replied to a patch and
said I've applied it, I inevitably have.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
