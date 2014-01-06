Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347AbaAFLT1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 06:19:27 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:50376 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754006AbaAFLTZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 06:19:25 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] cpufreq: try to resume policies which failed on last resume
Date: Mon, 06 Jan 2014 12:33:09 +0100
Message-ID: <43419777.Exys3DrW83@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc6+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <CAKohpon7u_1h+9rKQeC8J4Pqd_6bSajn7Ag8=COqczhbSPEgMA@mail.gmail.com>
References: <f9d7b0d5424e4443597d2ed39bec3fedd2b10d1e.1387848958.git.viresh.kumar@linaro.org> <87a9f92xnn.fsf@nemi.mork.no> <CAKohpon7u_1h+9rKQeC8J4Pqd_6bSajn7Ag8=COqczhbSPEgMA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 06, 2014 04:24:09 PM Viresh Kumar wrote:
> On 6 January 2014 16:19, Bjørn Mork <bjorn@mork.no> wrote:
> > I cancelled by pressing backspace while the image was being written.

Basically, stuff is still frozen at this point, but devices are fully
functional.  It's kind of like returning an error code from swsusp_write()
in hibernate() (kernel/power/hibernate.c).

> I will answer other queries on next mail, but a quick question:
> Do you get these warnings even if you don't cancel hibernation?

Good question. :-)

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
