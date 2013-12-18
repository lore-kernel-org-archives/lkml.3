Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab3LRILg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 03:11:36 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:33261 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab3LRILf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 03:11:35 -0500
Message-ID: <52B158DD.2070603@gmail.com>
Date: Wed, 18 Dec 2013 09:12:13 +0100
From: Francis Moreau <francis.moro@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: micky <micky_ching@realsil.com.cn>, wwang <wei_wang@realsil.com.cn>,
        Samuel Ortiz <sameo@linux.intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Jingoo Han <jg1.han@samsung.com>,
        "'Chris Ball'" <cjb@laptop.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "'Borislav Petkov'" <bp@alien8.de>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: 3.12: kernel panic when resuming from suspend to RAM (x86_64)
References: <20131117195358.GO27323@pd.tnic> <4523614.I5MBhorHFt@vostro.rjw.lan> <5292FF5D.1050304@gmail.com> <1821758.2MoNI3h1Mv@vostro.rjw.lan> <52985041.5050000@gmail.com> <alpine.DEB.2.02.1311290958560.30673@ionos.tec.linutronix.de> <5299FF38.7060203@gmail.com> <alpine.DEB.2.02.1312021145190.30673@ionos.tec.linutronix.de> <alpine.DEB.2.02.1312021219090.30673@ionos.tec.linutronix.de> <529D92D6.8050409@gmail.com> <20131209221721.GB8612@zurbaran> <52A670E4.5050501@realsil.com.cn> <52A674E0.2080407@realsil.com.cn> <52B00547.8030904@gmail.com> <52B11EF6.3060606@realsil.com.cn>
In-Reply-To: <52B11EF6.3060606@realsil.com.cn>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2013 05:05 AM, micky wrote:
> Hi:
> 
> It seems that the card-reader was removed during suspend or resume, is 
> that right? or did you removed by hand?

yes during a suspend/resume cycle.

> I want to know with Thomas' patch, after resume, is the card-reader and 
> card-reader driver still exist?

I'm not sure but IIRC it's still loaded in the kernel after resuming.

> if not exist, I also want to know which function called first, 
> rtsx_pci_resume or rtsx_pci_remove, can you determine it?
> And IRQ16 seems not handled by rtsx_pci driver, so with Thomas' patch, 
> is there still some go wrong?
> 

No idea, I'm simply an unfortunate user of that driver.

Aren't the information you're asking for already answered in the
previous posts ?

Thanks.
