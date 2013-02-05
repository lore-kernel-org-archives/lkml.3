Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab3BEL3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 06:29:31 -0500
Received: from service87.mimecast.com ([91.220.42.44]:47783 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193Ab3BEL3L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 06:29:11 -0500
From: Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>
To: Viresh Kumar <viresh.kumar@linaro.org>, Borislav Petkov <bp@alien8.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        Robin Randhawa <Robin.Randhawa@arm.com>,
        Steve Bannister <Steve.Bannister@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>
Date: Tue, 5 Feb 2013 11:29:04 +0000
Subject: RE: [PATCH 0/4] CPUFreq: Implement per policy instances of governors
Thread-Topic: [PATCH 0/4] CPUFreq: Implement per policy instances of
 governors
Thread-Index: Ac4DhD5MgaautMGJTaOEoECG5Z1EigAD5ltw
Message-ID: <80D6EFE2711DED4189C7C8F0430BFEA86D23D6A80E@BUNGLE.Emea.Arm.com>
References: <cover.1359976493.git.viresh.kumar@linaro.org>
	<5808458.pvV2iHpBWm@vostro.rjw.lan>
	<CAKohpok7RiJ_HKGi3r0vU26kNEtFKq==pMMoshT6Z2yy9ghemA@mail.gmail.com>
	<20130204123221.GA22340@pd.tnic>
	<CAKohpomcrtV3i9fL4zV6Mt0uDza-9pHTOsqTe2=C1t6mE6cpCQ@mail.gmail.com>
	<20130204130403.GD13909@pd.tnic>
	<CAKohpokuFC5gnTFcD3+RH3p5XaW8vBtyfq+Kej=d2J8tERdmoQ@mail.gmail.com>
	<20130204133648.GE13909@pd.tnic>
 <CAKohpokejWugM+wP5xcqp0F9AggLxuEf9Ox5fDViMxJh1c+kEw@mail.gmail.com>
In-Reply-To: <CAKohpokejWugM+wP5xcqp0F9AggLxuEf9Ox5fDViMxJh1c+kEw@mail.gmail.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, en-GB
MIME-Version: 1.0
X-MC-Unique: 113020511290901301
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Qualcomm's ARM based "krait". Currently shipping in millions of Android
> phones.
>
> http://en.wikipedia.org/wiki/Krait_(CPU)
>
> Thanks Charles for pointing it out, I knew there is one :)
>
> --
> viresh

> On 4 February 2013 19:06, Borislav Petkov <bp@alien8.de> wrote:
> > On Mon, Feb 04, 2013 at 06:55:25PM +0530, Viresh Kumar wrote:
>
> >> Its not only for multicluster system, but a system where multiple cpus
> >> have separate clock control and hence multiple policy structures.
> >
> > What are those systems? Examples?
>
> Qualcomm's ARM based "krait". Currently shipping in millions of Android
> phones.
>
> http://en.wikipedia.org/wiki/Krait_(CPU)
>
> Thanks Charles for pointing it out, I knew there is one :)
>
> --
> viresh

Actually shooting myself in the foot here, Krait is not such a great example because although you can use difference between frequencies you are less likely to use different tunables (not inconceivable but unlikely). The best examples systems are multi cluster and hereterogeneous systems, like the recently announced Samsung Exynos 5 octa http://en.wikipedia.org/wiki/Exynos_(system_on_chip). We will see more systems like this appearing, sporting low power cores combined with high performance ones, all running at the same time. I appreciate this is all very new, but more will come, and the requirement to have different tunables per cluster is very real. In ARM on our own multi cluster test chip, using an experimental version of this approach, we have seen good improvements in power consumption without compromising performance.

(Apologies ahead for any bit my mail server appends, not much I can do about it)

-- IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium.  Thank you.

