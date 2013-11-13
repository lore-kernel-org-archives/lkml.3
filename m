Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758755Ab3KMLan (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 06:30:43 -0500
Received: from mail-vb0-f51.google.com ([209.85.212.51]:63728 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712Ab3KMLak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 06:30:40 -0500
MIME-Version: 1.0
In-Reply-To: <CAFRkauACb7wPdisp-PEic_-ko5MhhnAyigcpg5gfjLEFUuJqGw@mail.gmail.com>
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
Date: Wed, 13 Nov 2013 19:30:38 +0800
Message-ID: <CACVXFVPPK-s8ToH0L06Rq0DY9cvfomyHpYKJ7ufbbVoJq69mnA@mail.gmail.com>
Subject: Re: kernel BUG at kernel/kallsyms.c:222!
From: Ming Lei <tom.leiming@gmail.com>
To: Axel Lin <axel.lin@ingics.com>
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

Hi Axel,

On Wed, Nov 13, 2013 at 5:58 PM, Axel Lin <axel.lin@ingics.com> wrote:
>
> Hi Ming,
> You missed "; then" in the end of if statement in your patch.
>
> So I got below error with your patch:
> scripts/link-vmlinux.sh: line 87: syntax error near unexpected token `fi'
> make: *** [vmlinuxclean] Error 2

Thanks for your test, and I have fixed it and post a formal one for merge,
and you can find these two patches on arm list, but forget to Cc you, sorry
for that.


Thanks,
-- 
Ming Lei
