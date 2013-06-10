Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab3FJNmw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 09:42:52 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:26046 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab3FJNmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 09:42:50 -0400
X-AuditID: cbfee61a-b7f3b6d000006edd-db-51b5d7d8d73e
Date: Mon, 10 Jun 2013 15:42:02 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Borislav Petkov <bp@alien8.de>, "Rafael J. Wysocky" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH 5/5] cpufreq:boost:Kconfig: Enable boost support at Kconfig
Message-id: <20130610154202.34b634b7@amdc308.digital.local>
In-reply-to: <CAKohponR3HtHMkvCCdzmAS+MMe0CawRYr-ome=SO80nLVaWbeQ@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1370502472-7249-6-git-send-email-l.majewski@samsung.com>
 <20130606155815.GB21272@pd.tnic>
 <20130610152027.3133d1ab@amdc308.digital.local>
 <CAKohponR3HtHMkvCCdzmAS+MMe0CawRYr-ome=SO80nLVaWbeQ@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42I5/e+xoO7N61sDDT5yWPx5u5zV4vOGf2wW
	T5t+sFvM+yxr0Xn2CbPFm0fcFpd3zWGz+Nx7hNHiduMKNov+hb1MFh1HvjFbbPzq4cDj8b21
	j8XjzrU9bB7rpr1l9ujbsorR49HiFkaPz5vkAtiiuGxSUnMyy1KL9O0SuDK2f1vPXNDEVrH+
	+HPmBsZLLF2MnBwSAiYSz+b9hbLFJC7cW8/WxcjFISQwnVHi5dXJjBBOO5NEd8NKJpAqFgFV
	idfTDzCC2GwCehKf7z4FinNwiAhoSby8mQpSzyzwiFni5MSXrCA1wgL+EnOOr2MHsXkFrCW6
	nh8Fm8MpECyx5P0+sBohgblMEqvXZoLY/AKSEu3/fjBDXGQnce7TBqheQYkfk++BXcoMtGvz
	tiZWCFteYvOat8wTGAVnISmbhaRsFpKyBYzMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGC
	Y+aZ1A7GlQ0WhxgFOBiVeHgf/NoSKMSaWFZcmXuIUYKDWUmEV3bL1kAh3pTEyqrUovz4otKc
	1OJDjNIcLErivAdarQOFBNITS1KzU1MLUotgskwcnFINjL3zZt7nDheYYiTDuSOXufv6+kez
	zRgL6k57uit4nN+dYJqkucv9sVJ8/L6jjM9y5+3Ksf+1aIf/YSlxDyfj13cvPd/CFZWvLHpD
	1jFXtPCV5eJL4k9S1uZNe/Kl69TNDQ6mJpMXHfzWtp+zR6qYK9ZOdrfBypOdBsxvF+eLXJjH
	I5myYbPocSWW4oxEQy3mouJEANmleSuVAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

> On 10 June 2013 18:50, Lukasz Majewski <l.majewski@samsung.com> wrote:
> > Hi,
> >
> >> On Thu, Jun 06, 2013 at 09:07:52AM +0200, Lukasz Majewski wrote:
> >> > Enable/disable support for BOOST. New flag - CPU_FREQ_BOOST has
> >> > been defined for that.
> >>
> >> What's the reason for this? Why would you want to not compile-in
> >> the boosting code?
> >
> > I think that this flag could be removed and the "boost" could be
> > compiled-in permanently.
> >
> > Viresh, what is your opinion?
> 
> Yes, Borislav is correct. I haven't actually reviewed these last
> patches as I saw lots of issues with first one :)

Ok, thanks :-)

-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
