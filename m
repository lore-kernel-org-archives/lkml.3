Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab3BEJgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:36:19 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:47196 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab3BEJgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:36:13 -0500
MIME-Version: 1.0
In-Reply-To: <20130204133648.GE13909@pd.tnic>
References: <cover.1359976493.git.viresh.kumar@linaro.org>
	<5808458.pvV2iHpBWm@vostro.rjw.lan>
	<CAKohpok7RiJ_HKGi3r0vU26kNEtFKq==pMMoshT6Z2yy9ghemA@mail.gmail.com>
	<20130204123221.GA22340@pd.tnic>
	<CAKohpomcrtV3i9fL4zV6Mt0uDza-9pHTOsqTe2=C1t6mE6cpCQ@mail.gmail.com>
	<20130204130403.GD13909@pd.tnic>
	<CAKohpokuFC5gnTFcD3+RH3p5XaW8vBtyfq+Kej=d2J8tERdmoQ@mail.gmail.com>
	<20130204133648.GE13909@pd.tnic>
Date: Tue, 5 Feb 2013 15:06:12 +0530
Message-ID: <CAKohpokejWugM+wP5xcqp0F9AggLxuEf9Ox5fDViMxJh1c+kEw@mail.gmail.com>
Subject: Re: [PATCH 0/4] CPUFreq: Implement per policy instances of governors
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Borislav Petkov <bp@alien8.de>, Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 February 2013 19:06, Borislav Petkov <bp@alien8.de> wrote:
> On Mon, Feb 04, 2013 at 06:55:25PM +0530, Viresh Kumar wrote:

>> Its not only for multicluster system, but a system where multiple cpus
>> have separate clock control and hence multiple policy structures.
>
> What are those systems? Examples?

Qualcomm's ARM based "krait". Currently shipping in millions of Android
phones.

http://en.wikipedia.org/wiki/Krait_(CPU)

Thanks Charles for pointing it out, I knew there is one :)

--
viresh
