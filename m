Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933855Ab3CHHUm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 02:20:42 -0500
Received: from www.linutronix.de ([62.245.132.108]:52971 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389Ab3CHHUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 02:20:41 -0500
Date: Fri, 8 Mar 2013 08:20:33 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
cc: john.stultz@linaro.org, viresh.kumar@linaro.org,
        jacob.jun.pan@linux.intel.com,
        LAK <linux-arm-kernel@lists.infradead.org>, santosh.shilimkar@ti.com,
        linux-pm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        rickard.andersson@stericsson.com, vincent.guittot@linaro.org,
        linus.walleij@stericsson.com, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 2/4][V2] time : set broadcast irq affinity
In-Reply-To: <51396B39.3090504@linaro.org>
Message-ID: <alpine.LFD.2.02.1303080817230.22263@ionos>
References: <1362219013-18173-1-git-send-email-daniel.lezcano@linaro.org> <1362219013-18173-3-git-send-email-daniel.lezcano@linaro.org> <alpine.LFD.2.02.1303052135080.22263@ionos> <51370C09.5020301@linaro.org> <alpine.LFD.2.02.1303061047240.22263@ionos>
 <51396B39.3090504@linaro.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Mar 2013, Daniel Lezcano wrote:
> On 03/06/2013 10:48 AM, Thomas Gleixner wrote:
> I was wondering if it would be possible to take the 3/4 and 4/4
> otherwise the flag dependency will prevent to send those to the
> maintainer's tree until they gain visibility on it.

I can take them with the ack of arm soc folks.

Thanks,

	tglx
