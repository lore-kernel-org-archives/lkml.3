Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933393Ab3CYVw6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 17:52:58 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:60185 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933210Ab3CYVw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 17:52:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Brown <davidb@codeaurora.org>
Subject: Re: [GIT PULL] msm fix for 3.9 -- timer
Date: Mon, 25 Mar 2013 21:52:30 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, Olof Johansson <olof@lixom.net>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>
References: <8ya8v5b88aj.fsf@huya.qualcomm.com>
In-Reply-To: <8ya8v5b88aj.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303252152.30806.arnd@arndb.de>
X-Provags-ID: V02:K0:gF2ovdXx6vySzazA/rfokHSGzVvCg9Hy5dCjo9OL5bm
 fMLNmiZnrN5b6yMvjNK6UG1cOJnPyTWULhIxhuB+CmFLqdMncp
 vm4i6nBc+gD2TysHmeQcthbxIFw1Fg1IbtCfJkux4AaWmE7cGw
 heIoYDSIfdtksEA4OL09rAdJeFj0bKcynbwNYYMFyacQf3v3oE
 m1qQPSbAiNZTmcaaTB6HXOO9lvujgwop8jTZDAdVdBJHXgfPFU
 sKd0B2SO19ouWuSJYwddupr3Vq/jRSi8KZ8gam948BNzlT5+4p
 PWZl9xwgsXY8o2dRuHUtJ2Fjcq7Yo7k3QDW45qtCCODMld5wfT
 BvJd4pMyMY2fVPtcezEE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 March 2013, David Brown wrote:
> The following changes since commit f6161aa153581da4a3867a2d1a7caf4be19b6ec9:
> 
>   Linux 3.9-rc2 (2013-03-10 16:54:19 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git tags/msm-fix-3.9
> 
> for you to fetch changes up to 4080d2d11a2d572228c2b8d02406e997b87ba6a5:
> 
>   ARM: msm: Stop counting before reprogramming clockevent (2013-03-22 10:45:39 -0700)
> 
> ----------------------------------------------------------------
> This fix is intended for v3.9.  It fixes a timer bug on MSM targets
> that cause system hangs.

Pulled into the fixes branch. You just missed 3.9-rc5 as Linus pulled the
branch today, but it I will send it for -rc6.

Should the patch be marked for backports to stable?

	Arnd
