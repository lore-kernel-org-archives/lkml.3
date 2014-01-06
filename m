Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbaAFLAb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 06:00:31 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:51026 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752082AbaAFLA3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 06:00:29 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] cpufreq: try to resume policies which failed on last resume
Date: Mon, 06 Jan 2014 12:14:13 +0100
Message-ID: <2207601.6Y4Zru5qMP@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc6+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <87a9f92xnn.fsf@nemi.mork.no>
References: <f9d7b0d5424e4443597d2ed39bec3fedd2b10d1e.1387848958.git.viresh.kumar@linaro.org> <CAKohpo=KgHqz0KYv7h0EYP3=8h7T3ZfPpFTMS6qVoEb6dXGnSQ@mail.gmail.com> <87a9f92xnn.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 06, 2014 11:49:00 AM Bjørn Mork wrote:
> Viresh Kumar <viresh.kumar@linaro.org> writes:
> 
> > On 6 January 2014 14:31, Bjørn Mork <bjorn@mork.no> wrote:
> >> That's correct.  I have not observed this on suspend to RAM.  But then
> >> again I haven't rigged any way to log that, so I don't think it's
> >> conclusive..
> >>
> >> The point I tried to make is that it isn't related to any hibernation
> >> *failures*.  The warning appears even if the add_dev() is successful,
> >> and it also appears if I touch only the *boot* cpu cpufreq attributes.
> >
> > Okay.. But your log below is for add_dev() failure case.
> 
> Any suggestion on how to capure warnings issued between freeze and thaw
> is appreciated :-)

You can try to add no_console_suspend to the kernel's command line.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
