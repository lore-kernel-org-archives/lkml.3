Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab3BENzt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 08:55:49 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:41524 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340Ab3BENzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 08:55:46 -0500
MIME-Version: 1.0
In-Reply-To: <20130205132241.GH4827@pd.tnic>
References: <20130205091532.GA4827@pd.tnic>
	<CAKohpo=6q+Bcgq0Re=3SXM6zwub5N=vJBO=sTeEgZZ9byFK7=g@mail.gmail.com>
	<20130205102721.GB4827@pd.tnic>
	<CAKohpo=_Qq-_Aqy7nZD+f28-B7DY8ioQ5fe8bYKTe64A0RXeGw@mail.gmail.com>
	<20130205110407.GC4827@pd.tnic>
	<CAKohponiiVO_P2EDDTUHeoo7j3FG-ELtP8oLwfdEQ3HkgOS77g@mail.gmail.com>
	<20130205111918.GD4827@pd.tnic>
	<CAKohpomUsDr0YJmOxjymcAAJnfOxKfzxGL4iHuif1qCAvy0OYA@mail.gmail.com>
	<20130205113242.GF4827@pd.tnic>
	<CAKohpo=ABkc3ku=YrS7=Df_65s3OPg+eAa80gCEkiK4dNc+x4g@mail.gmail.com>
	<20130205132241.GH4827@pd.tnic>
Date: Tue, 5 Feb 2013 19:25:44 +0530
Message-ID: <CAKohpomdH_s4xMtUo8-hSBEYqRVTEo5eCUG=vH4K5WckUi2KiQ@mail.gmail.com>
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

On 5 February 2013 18:52, Borislav Petkov <bp@alien8.de> wrote:
> On Tue, Feb 05, 2013 at 05:54:57PM +0530, Viresh Kumar wrote:q
>> This indication isn't enough. On a single image solution, we need to
>> identify the system which needs support for multiple policies and i
>> still feel we need that variable type indication :)
>
> If the image is going to run also on systems which support only a
> single policy, then I guess you can make it a bool, stuff it in struct
> cpufreq_policy and ifdef around it.

That's what i proposed initially.
