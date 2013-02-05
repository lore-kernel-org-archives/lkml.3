Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab3BEKn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 05:43:27 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:46977 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab3BEKnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 05:43:24 -0500
MIME-Version: 1.0
In-Reply-To: <20130205102721.GB4827@pd.tnic>
References: <20130204133648.GE13909@pd.tnic>
	<CAKohpo=aLnhM0Op_32ohWZK5eG5nT7iK0OktBe+8ygOQW7zUqQ@mail.gmail.com>
	<20130204140908.GC15452@pd.tnic>
	<CAKohpokowK6ybYd8aDUdfFYsnzoc5VAKsuPSkfxoDqJ3k+FwGA@mail.gmail.com>
	<20130204150511.GF13909@pd.tnic>
	<CAKohpokt0xtsj1eQDMw6JgvQVp4rgFyU-vUrtuuF+0jjOVNHRQ@mail.gmail.com>
	<20130204165057.GH13909@pd.tnic>
	<CAOh2x==fyfYwz+eXmPhBJTE+_q_fHyx2drXrM789XvCfEqPBUQ@mail.gmail.com>
	<20130205091532.GA4827@pd.tnic>
	<CAKohpo=6q+Bcgq0Re=3SXM6zwub5N=vJBO=sTeEgZZ9byFK7=g@mail.gmail.com>
	<20130205102721.GB4827@pd.tnic>
Date: Tue, 5 Feb 2013 16:13:23 +0530
Message-ID: <CAKohpo=_Qq-_Aqy7nZD+f28-B7DY8ioQ5fe8bYKTe64A0RXeGw@mail.gmail.com>
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

On 5 February 2013 15:57, Borislav Petkov <bp@alien8.de> wrote:
> Are you kidding me? You're simply not reading what I'm saying to you:
> "... should be optional and selectable in Kconfig so that systems which
> don't need that, don't have to see or use it." Because on those systems
> it doesn't apply.
>
> How about we add an x86-specific extension which is a big wad of code
> and is needlessly run on ARM just because it is easier?

There isn't lot of code that we have to keep inside the macro you suggest.
Its just an if else (with single line block), which would give the parent
kobject. Nothing else.

I didn't wanted to create a macro for just that. For me an if/else is not that
big code.

Anyway, if nobody else comes on my side i can create that macro for you.
But, personally i would prefer code without such macros.

--
viresh
