Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906Ab3LIWRa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 17:17:30 -0500
Received: from mga11.intel.com ([192.55.52.93]:24597 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474Ab3LIWR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 17:17:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,860,1378882800"; 
   d="scan'208";a="447251616"
Date: Mon, 9 Dec 2013 23:17:21 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Francis Moreau <francis.moro@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jingoo Han <jg1.han@samsung.com>,
        "'Wei WANG'" <wei_wang@realsil.com.cn>,
        "'Chris Ball'" <cjb@laptop.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "'Borislav Petkov'" <bp@alien8.de>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: 3.12: kernel panic when resuming from suspend to RAM (x86_64)
Message-ID: <20131209221721.GB8612@zurbaran>
References: <20131117195358.GO27323@pd.tnic>
 <4523614.I5MBhorHFt@vostro.rjw.lan>
 <5292FF5D.1050304@gmail.com>
 <1821758.2MoNI3h1Mv@vostro.rjw.lan>
 <52985041.5050000@gmail.com>
 <alpine.DEB.2.02.1311290958560.30673@ionos.tec.linutronix.de>
 <5299FF38.7060203@gmail.com>
 <alpine.DEB.2.02.1312021145190.30673@ionos.tec.linutronix.de>
 <alpine.DEB.2.02.1312021219090.30673@ionos.tec.linutronix.de>
 <529D92D6.8050409@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529D92D6.8050409@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Francis,

Adding Lee to the Cc list.

On Tue, Dec 03, 2013 at 09:14:14AM +0100, Francis Moreau wrote:
> Now that you did the hard work, I hope driver's maintainer/developper
> will care about this issue.
I applied Thomas' patch to mfd-fixes.
Thanks a lot to you and Thomas for that.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
