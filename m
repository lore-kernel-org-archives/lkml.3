Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366Ab3LJKs5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 05:48:57 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:56330 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab3LJKs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 05:48:56 -0500
Message-ID: <52A6F1BA.3030903@gmail.com>
Date: Tue, 10 Dec 2013 11:49:30 +0100
From: Francis Moreau <francis.moro@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Jingoo Han <jg1.han@samsung.com>,
        "'Wei WANG'" <wei_wang@realsil.com.cn>,
        "'Chris Ball'" <cjb@laptop.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "'Borislav Petkov'" <bp@alien8.de>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: 3.12: kernel panic when resuming from suspend to RAM (x86_64)
References: <20131117195358.GO27323@pd.tnic> <4523614.I5MBhorHFt@vostro.rjw.lan> <5292FF5D.1050304@gmail.com> <1821758.2MoNI3h1Mv@vostro.rjw.lan> <52985041.5050000@gmail.com> <alpine.DEB.2.02.1311290958560.30673@ionos.tec.linutronix.de> <5299FF38.7060203@gmail.com> <alpine.DEB.2.02.1312021145190.30673@ionos.tec.linutronix.de> <alpine.DEB.2.02.1312021219090.30673@ionos.tec.linutronix.de> <529D92D6.8050409@gmail.com> <20131209221721.GB8612@zurbaran>
In-Reply-To: <20131209221721.GB8612@zurbaran>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 12/09/2013 11:17 PM, Samuel Ortiz wrote:
> Hi Francis,
> 
> Adding Lee to the Cc list.
> 
> On Tue, Dec 03, 2013 at 09:14:14AM +0100, Francis Moreau wrote:
>> Now that you did the hard work, I hope driver's maintainer/developper
>> will care about this issue.
> I applied Thomas' patch to mfd-fixes.
> Thanks a lot to you and Thomas for that.

Please, don't forget to propagate the fix to the affected stable trees.

Thanks.

