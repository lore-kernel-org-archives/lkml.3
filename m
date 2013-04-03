Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759268Ab3DCLHG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 07:07:06 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:50685 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552Ab3DCLHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 07:07:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>, stratosk <stratosk@semaphore.gr>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 linux-next] cpufreq: ondemand: Calculate gradient of CPU load to early increase frequency
Date: Wed, 03 Apr 2013 13:14:39 +0200
Message-ID: <3060957.HxB12olH3c@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohponUuwiQ9EiKq66Mgf7zZxonxHs=DNbhx=uydDVB5bed6w@mail.gmail.com>
References: <ore61p9gvaic2j0fc083dpbd.1364970699079@email.android.com> <CAKohponUuwiQ9EiKq66Mgf7zZxonxHs=DNbhx=uydDVB5bed6w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 03, 2013 12:13:56 PM Viresh Kumar wrote:
> On 3 April 2013 12:01, stratosk <stratosk@semaphore.gr> wrote:
> > I'm sorry, I don't understand.
> > The goal of this patch is not energy saving.
> 
> He probably misunderstood it...
> 
> > The goal is to detect CPU load as soon as possible to increase frequency.
> >
> > Could you please clarify this?
> 
> But he is looking for some numbers to prove your patch. Some numbers
> that shows performance is better with your changes...

Yes.  If the goal of the patch is to improve performance, it would be good to
know that it does meet the goal. IOW, *something* is supposed to be better with
the patch and if so, numbers in support of this should be provided.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
