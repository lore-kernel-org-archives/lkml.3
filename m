Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642Ab3LJBk7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 20:40:59 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:43893 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab3LJBk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 20:40:57 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.38 with qID rBA1dqXb025283, This message is accepted by code: ctloc85258
Message-ID: <52A670E4.5050501@realsil.com.cn>
Date: Tue, 10 Dec 2013 09:39:48 +0800
From: wwang <wei_wang@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>,
        Francis Moreau <francis.moro@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Jingoo Han <jg1.han@samsung.com>,
        "'Chris Ball'" <cjb@laptop.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "'Borislav Petkov'" <bp@alien8.de>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "Lee Jones" <lee.jones@linaro.org>, micky <micky_ching@realsil.com.cn>
Subject: Re: 3.12: kernel panic when resuming from suspend to RAM (x86_64)
References: <20131117195358.GO27323@pd.tnic> <4523614.I5MBhorHFt@vostro.rjw.lan> <5292FF5D.1050304@gmail.com> <1821758.2MoNI3h1Mv@vostro.rjw.lan> <52985041.5050000@gmail.com> <alpine.DEB.2.02.1311290958560.30673@ionos.tec.linutronix.de> <5299FF38.7060203@gmail.com> <alpine.DEB.2.02.1312021145190.30673@ionos.tec.linutronix.de> <alpine.DEB.2.02.1312021219090.30673@ionos.tec.linutronix.de> <529D92D6.8050409@gmail.com> <20131209221721.GB8612@zurbaran>
In-Reply-To: <20131209221721.GB8612@zurbaran>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.29.41.8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2013 06:17 AM, Samuel Ortiz wrote:
> Hi Francis,
>
> Adding Lee to the Cc list.
>
> On Tue, Dec 03, 2013 at 09:14:14AM +0100, Francis Moreau wrote:
>> Now that you did the hard work, I hope driver's maintainer/developper
>> will care about this issue.
> I applied Thomas' patch to mfd-fixes.
> Thanks a lot to you and Thomas for that.
>
> Cheers,
> Samuel.
>

Hi Samuel:

Add Micky to the list, who is responsible for maintaining this driver now.

We can't reproduce this issue with our platform, so it seems a little 
difficult for us to catch the point. We have tested Thomas' patch, it's 
OK with our platform. But we find it maybe not very complete.
Micky will send his patch later, which is based on Thomas' patch.

BR,
Wei



