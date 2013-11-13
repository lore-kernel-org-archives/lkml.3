Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152Ab3KMEmE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 23:42:04 -0500
Received: from mail-ve0-f172.google.com ([209.85.128.172]:49696 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757527Ab3KMEl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 23:41:56 -0500
MIME-Version: 1.0
In-Reply-To: <52826706.2080508@arm.com>
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
	<52826706.2080508@arm.com>
Date: Wed, 13 Nov 2013 12:41:55 +0800
Message-ID: <CACVXFVPauU_8BTPtutF8_pDT-KCw_P+gVs4z+X227qm7629AhQ@mail.gmail.com>
Subject: Re: kernel BUG at kernel/kallsyms.c:222!
From: Ming Lei <tom.leiming@gmail.com>
To: Jonathan Austin <Jonathan.Austin@arm.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Michal Marek <mmarek@suse.cz>, Rusty Russell <rusty@rustcorp.com.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Axel Lin <axel.lin@ingics.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 1:36 AM, Jonathan Austin
<Jonathan.Austin@arm.com> wrote:
>> Currently, I suggest to filter only on ARM as attachment patch if we plan
>> to merge Jonathan's patch, otherwise a more complicated approach has
>> to be figured out  to do the filter(such as, define a readonly symbol in
>> kernel to store PAGE_OFFSET, and let scripts/kallsyms use it for
>> filtering).
>
>
> I'm happy with that approach, though allowing only ARM seems a bit
> conservative - is it the only architecture we actually expect to work?

Yes, the problem is only reported on ARM, so let's do it.


Thanks,
-- 
Ming Lei
