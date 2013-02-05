Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab3BEL0I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 06:26:08 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:51046 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab3BEL0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 06:26:05 -0500
MIME-Version: 1.0
In-Reply-To: <20130205111918.GD4827@pd.tnic>
References: <20130204150511.GF13909@pd.tnic>
	<CAKohpokt0xtsj1eQDMw6JgvQVp4rgFyU-vUrtuuF+0jjOVNHRQ@mail.gmail.com>
	<20130204165057.GH13909@pd.tnic>
	<CAOh2x==fyfYwz+eXmPhBJTE+_q_fHyx2drXrM789XvCfEqPBUQ@mail.gmail.com>
	<20130205091532.GA4827@pd.tnic>
	<CAKohpo=6q+Bcgq0Re=3SXM6zwub5N=vJBO=sTeEgZZ9byFK7=g@mail.gmail.com>
	<20130205102721.GB4827@pd.tnic>
	<CAKohpo=_Qq-_Aqy7nZD+f28-B7DY8ioQ5fe8bYKTe64A0RXeGw@mail.gmail.com>
	<20130205110407.GC4827@pd.tnic>
	<CAKohponiiVO_P2EDDTUHeoo7j3FG-ELtP8oLwfdEQ3HkgOS77g@mail.gmail.com>
	<20130205111918.GD4827@pd.tnic>
Date: Tue, 5 Feb 2013 16:56:03 +0530
Message-ID: <CAKohpomUsDr0YJmOxjymcAAJnfOxKfzxGL4iHuif1qCAvy0OYA@mail.gmail.com>
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

On 5 February 2013 16:49, Borislav Petkov <bp@alien8.de> wrote:
> On Tue, Feb 05, 2013 at 04:42:23PM +0530, Viresh Kumar wrote:
>> Tricky part is the name of this routine: add_additional_sysfs_entries().
>
> Now you're just being silly - this is just an example how to do it. If
> you want me to do it for ya, you need to send me your monthly salary.

Haha... I don't want you to do it. I don't want such routine to be exposed
to cpufreq drivers as this belongs to the core code.

Just some kind of indication from platform driver is required about
how/where it wants its governor directory to be present.
And the variable suits more here.

Lets discuss it more on the next patch i send :)

--
viresh
