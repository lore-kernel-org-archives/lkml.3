Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899AbaFDUGy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 16:06:54 -0400
Received: from www.linutronix.de ([62.245.132.108]:41087 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbaFDUGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 16:06:53 -0400
Date: Wed, 4 Jun 2014 22:06:39 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
cc: john.stultz@linaro.org, prarit@redhat.com, paul.gortmaker@windriver.com,
        juri.lelli@gmail.com, ddaney.cavm@gmail.com, mbohan@codeaurora.org,
        david.vrabel@citrix.com, david.engraf@sysgo.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] hrtimers: calculate expires_next after all timers
 are executed
In-Reply-To: <20140604154745.GE26511@stfomichev-desktop.yandex.net>
Message-ID: <alpine.DEB.2.10.1406042205150.18296@nanos>
References: <1395067037-20060-1-git-send-email-stfomichev@yandex-team.ru> <alpine.DEB.2.02.1403191149460.18573@ionos.tec.linutronix.de> <20140319141615.GB11081@stfomichev-desktop.yandex.net> <20140604154745.GE26511@stfomichev-desktop.yandex.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2014, Stanislav Fomichev wrote:

> Thomas, any estimate on when you'll be able to review this patch?
> It's been almost 3 months since is sent it. Is there any particular
> reason you don't want to pull it (because on my machines it's
> been working fine without any issues)?

It's in my ever growing backlog. :(

I'm trying to get it into 3.16 though.

Thanks,

	tglx
