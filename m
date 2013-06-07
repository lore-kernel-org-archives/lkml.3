Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421Ab3FGLHa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 07:07:30 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:59445 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047Ab3FGLH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 07:07:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Lists linaro-dev <linaro-dev@lists.linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [GIT PULL] CPUFreq: ARM Updates for v3.11
Date: Fri, 07 Jun 2013 13:16:34 +0200
Message-ID: <4129326.tFXhKE6MIr@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohponx-dSdRVX77Fa8ePKhppvvE=dS=ofJT0_+3014b38ZOg@mail.gmail.com>
References: <CAKohpokdrw1KZuCx6Y5E1JyK-Yq0T1fh0qP+bEaqgZjoK8JEEQ@mail.gmail.com> <54837539.yBQlA0EhhC@vostro.rjw.lan> <CAKohponx-dSdRVX77Fa8ePKhppvvE=dS=ofJT0_+3014b38ZOg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 07, 2013 04:35:24 PM Viresh Kumar wrote:
> On 7 June 2013 16:41, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Friday, June 07, 2013 04:26:36 PM Viresh Kumar wrote:
> 
> >>       cpufreq: bit.LITTLE needs cpufreq table
> >
> > That should be big.LITTLE I suppose?
> 
> Yes. This is not the first time I face this issue where big is
> written as bit. Even I named one of my external repo like this
> earlier and after a long time some other careful viewer caught
> it :)
> 
> Fixed my branch now with s/bit/big.

OK, thanks!

Care to resend the request, since the commit IDs have changed?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
