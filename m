Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161630Ab3DEKh7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 06:37:59 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:51808 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161349Ab3DEKh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 06:37:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, robin.randhawa@arm.com, Steve.Bannister@arm.com,
        Liviu.Dudau@arm.com, charles.garcia-tobin@arm.com,
        arvind.chauhan@arm.com, Sekhar Nori <nsekhar@ti.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>, Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] cpufreq: Raname index as data in cpufreq_frequency_table
Date: Fri, 05 Apr 2013 12:45:33 +0200
Message-ID: <2281585.KIHsrTRMxO@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohpo=jUOciKCAWWJ_bC-uSKzdk4a49r39gaOsuroVbqSRyFg@mail.gmail.com>
References: <03ca6f17860d290cfc67e51969062612f0ab26ab.1364643234.git.viresh.kumar@linaro.org> <CAKohpo=wNHsV0vFhcTWg0g7=Wtbdx=g2wqpNPfidQfGhhK9Cig@mail.gmail.com> <CAKohpo=jUOciKCAWWJ_bC-uSKzdk4a49r39gaOsuroVbqSRyFg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 05, 2013 04:00:04 PM Viresh Kumar wrote:
> On 31 March 2013 09:16, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> > On 31 March 2013 07:16, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> On Sunday, March 31, 2013 07:03:04 AM Viresh Kumar wrote:
> >>> On 31 March 2013 03:31, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >>> > Sorry, I won't apply this.  It changes too much stuff at a time and I'm not
> >>> > really sure if the change being made is necessary.
> >>>
> >>> Hmm.. I thought it is important  as it puts the real meaning of "index" in the
> >>> code.
> >>
> >> And what does that change, really?  What about documenting the meaning of
> >> "index" instead?
> >
> > Probably not the logic but perception. People don't necessarily go through
> > Documentation but code for writing new stuff. And so code should reflect the
> > real meaning.
> >
> > In case we write something like following in documentation:
> > "Index: This is driver specific data for each frequency. Core doesn't use it."
> >
> > Then "Index" looks even more wrong. Its not the right name for any such
> > variable. And so it should be fixed.
> 
> Forgot reply to all earlier :(
> 
> You have any more comments on this patch? I really thought this change
> would be good. I agree it touches lot of stuff but for clean/clear code.

OK

Please resend it after v3.10-rc1 and I'll take it for v3.11.  Surely, it can
wait for that long.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
