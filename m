Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbaBMJqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 04:46:10 -0500
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:51326 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751440AbaBMJqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 04:46:08 -0500
Message-ID: <1392284765.30853.21.camel@x220>
Subject: Re: [uclinux-dist-devel] [PATCH] blackfin: bf60x: fix typo
 "CONFIG_PM_BFIN_WAKE_PA15_POL"
From: Paul Bolle <pebolle@tiscali.nl>
To: Steven Miao <realmz6@gmail.com>
Cc: adi-buildroot-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Date: Thu, 13 Feb 2014 10:46:05 +0100
In-Reply-To: <CAMk6uBmNHb0t1zetK8+gkKMOj7843cRsz_f1m5zP4dPncuKwoA@mail.gmail.com>
References: <1363736001.1390.53.camel@x61.thuisdomein>
	 <CAMk6uBmNHb0t1zetK8+gkKMOj7843cRsz_f1m5zP4dPncuKwoA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Feb 2014 09:46:06.0362 (UTC) FILETIME=[6A7EFFA0:01CF28A0]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added current lists.]

On Wed, 2013-03-20 at 13:26 +0800, Steven Miao wrote:
> good catch, thanks

This typo is still present in v3.14-rc2. Was my patch perhaps lost?

> On Wed, Mar 20, 2013 at 7:33 AM, Paul Bolle <pebolle@tiscali.nl>
> wrote:
>         Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
>         ---
>         Obvious, isn't it? Introduced in v3.5, through commit
>         0fbd88ca20a68a633b565e1f5ba18ca64afb0c78 ("blackfin: bf60x:
>         add wakeup source select"). Untested.
>         
>          arch/blackfin/mach-bf609/pm.c | 2 +-
>          1 file changed, 1 insertion(+), 1 deletion(-)
>         
>         diff --git a/arch/blackfin/mach-bf609/pm.c
>         b/arch/blackfin/mach-bf609/pm.c
>         index ad505d9..0cdd695 100644
>         --- a/arch/blackfin/mach-bf609/pm.c
>         +++ b/arch/blackfin/mach-bf609/pm.c
>         @@ -210,7 +210,7 @@ void bf609_cpu_pm_enter(suspend_state_t
>         state)
>         
>          #ifdef CONFIG_PM_BFIN_WAKE_PB15
>                 wakeup |= PB15WE;
>         -# if CONFIG_PM_BFIN_WAKE_PA15_POL
>         +# if CONFIG_PM_BFIN_WAKE_PB15_POL
>                 wakeup_pol |= PB15WE;
>          # endif
>          #endif
>         --
>         1.7.11.7


Paul Bolle

