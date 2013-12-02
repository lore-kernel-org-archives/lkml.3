Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab3LBB5n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 20:57:43 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:64483 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab3LBB5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 20:57:40 -0500
MIME-Version: 1.0
X-Originating-IP: [111.240.61.77]
In-Reply-To: <CACVXFVPPK-s8ToH0L06Rq0DY9cvfomyHpYKJ7ufbbVoJq69mnA@mail.gmail.com>
References: <CACVXFVNHryPXy2NQhPwXkoCeLUXQSgrWmgBkMNtGD_=X_62_5Q@mail.gmail.com>
	<CAFRkauDGiy3yZOwKFWMEJvYUe0OoXMEZHKaxogZHdgzMxexdHA@mail.gmail.com>
	<CACVXFVMAnewCkSNNke3kf1-yO+JCc_HBRp8iaLBPJ+14G79Haw@mail.gmail.com>
	<87y54vzszo.fsf@rustcorp.com.au>
	<CAFRkauBYUq3UAjqLvkuDVEz5BVyDpC0DuVRGTe4K+kcoCX17GA@mail.gmail.com>
	<CACVXFVMvvG1unnR0rsmBMdp9p19Q3JRbURxZF-UWxvrThDPKTw@mail.gmail.com>
	<CAFRkauCW3FDSuh4t0gvmSWH1m0+qaG0XSoBxmk30Wq1FMy7iFw@mail.gmail.com>
	<CACVXFVMzOzD+D-MQCUBvC80d4zS-TJfcucKuUvzerGs6gT1fEg@mail.gmail.com>
	<CACVXFVOnVXcVdRCm=OfPjpvvWCiXi8GRV+9ViOGmSZ3tTf6WDg@mail.gmail.com>
	<528110B1.4060402@arm.com>
	<20131111193236.GB16735@n2100.arm.linux.org.uk>
	<CACVXFVPQfUtrc4r4cS9J+6q5Z6hGZDgafH=M_6JfrzrAUGJOHw@mail.gmail.com>
	<CAFRkauACb7wPdisp-PEic_-ko5MhhnAyigcpg5gfjLEFUuJqGw@mail.gmail.com>
	<CACVXFVPPK-s8ToH0L06Rq0DY9cvfomyHpYKJ7ufbbVoJq69mnA@mail.gmail.com>
Date: Mon, 2 Dec 2013 09:57:39 +0800
Message-ID: <CAFRkauCFdBFM3L9DA2i7jGDRPe4V5AQA2o-ZsZB7HYA-zvzHAA@mail.gmail.com>
Subject: Re: kernel BUG at kernel/kallsyms.c:222!
From: Axel Lin <axel.lin@ingics.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jonathan Austin <jonathan.austin@arm.com>,
        Michal Marek <mmarek@suse.cz>, Rusty Russell <rusty@rustcorp.com.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/11/13 Ming Lei <tom.leiming@gmail.com>:
> Hi Axel,
>
> On Wed, Nov 13, 2013 at 5:58 PM, Axel Lin <axel.lin@ingics.com> wrote:
>>
>> Hi Ming,
>> You missed "; then" in the end of if statement in your patch.
>>
>> So I got below error with your patch:
>> scripts/link-vmlinux.sh: line 87: syntax error near unexpected token `fi'
>> make: *** [vmlinuxclean] Error 2
>
> Thanks for your test, and I have fixed it and post a formal one for merge,
> and you can find these two patches on arm list, but forget to Cc you, sorry
> for that.

Hi Ming,
Both your patch and Jonathan's patch are still not in linux-next.
Any chance to resend the patchs to RMK's patch system?

Thanks,
Axel
