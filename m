Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845AbaBZK3Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 05:29:16 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:59546 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbaBZK3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 05:29:14 -0500
MIME-Version: 1.0
In-Reply-To: <1392284765.30853.21.camel@x220>
References: <1363736001.1390.53.camel@x61.thuisdomein>
	<CAMk6uBmNHb0t1zetK8+gkKMOj7843cRsz_f1m5zP4dPncuKwoA@mail.gmail.com>
	<1392284765.30853.21.camel@x220>
Date: Wed, 26 Feb 2014 18:29:14 +0800
Message-ID: <CAMk6uBmk64pa0KF9yocd9z3jDriysaCcDKOPMBQbNkt8KLOp5g@mail.gmail.com>
Subject: Re: [uclinux-dist-devel] [PATCH] blackfin: bf60x: fix typo "CONFIG_PM_BFIN_WAKE_PA15_POL"
From: Steven Miao <realmz6@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: bfin <adi-buildroot-devel@lists.sourceforge.net>,
        "open list:CAN NETWORK DRIVERS <linux-can@vger.kernel.org>, open
	list:NETWORKING DRIVERS <netdev@vger.kernel.org>, open list" 
	<linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Thu, Feb 13, 2014 at 5:46 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> [Added current lists.]
>
> On Wed, 2013-03-20 at 13:26 +0800, Steven Miao wrote:
>> good catch, thanks
>
> This typo is still present in v3.14-rc2. Was my patch perhaps lost?
Sorry for the late reply. I'v applied this patch to the blackfin tree
at that time, but it seems we made some mistakes after the maintainer
changed. I will apply it to 3.14 release.

>
>> On Wed, Mar 20, 2013 at 7:33 AM, Paul Bolle <pebolle@tiscali.nl>
>> wrote:
>>         Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
>>         ---
>>         Obvious, isn't it? Introduced in v3.5, through commit
>>         0fbd88ca20a68a633b565e1f5ba18ca64afb0c78 ("blackfin: bf60x:
>>         add wakeup source select"). Untested.
>>
>>          arch/blackfin/mach-bf609/pm.c | 2 +-
>>          1 file changed, 1 insertion(+), 1 deletion(-)
>>
>>         diff --git a/arch/blackfin/mach-bf609/pm.c
>>         b/arch/blackfin/mach-bf609/pm.c
>>         index ad505d9..0cdd695 100644
>>         --- a/arch/blackfin/mach-bf609/pm.c
>>         +++ b/arch/blackfin/mach-bf609/pm.c
>>         @@ -210,7 +210,7 @@ void bf609_cpu_pm_enter(suspend_state_t
>>         state)
>>
>>          #ifdef CONFIG_PM_BFIN_WAKE_PB15
>>                 wakeup |= PB15WE;
>>         -# if CONFIG_PM_BFIN_WAKE_PA15_POL
>>         +# if CONFIG_PM_BFIN_WAKE_PB15_POL
>>                 wakeup_pol |= PB15WE;
>>          # endif
>>          #endif
>>         --
>>         1.7.11.7
>
>
> Paul Bolle
>
-steven
