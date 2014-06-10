Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbaFJU0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:26:14 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:51990 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754271AbaFJU0L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 16:26:11 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>, dirk.j.brandewie@intel.com,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/7] cpufreq: intel_pstate: Trivial code cleanup
Date: Tue, 10 Jun 2014 22:43:35 +0200
Message-ID: <1875587.zmLYOIAyby@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5397673D.8010200@semaphore.gr>
References: <5396208F.6070400@semaphore.gr> <5753346.hxK14sqO5y@vostro.rjw.lan> <5397673D.8010200@semaphore.gr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 10, 2014 11:14:53 PM Stratos Karafotis wrote:
> On 10/06/2014 11:17 μμ, Rafael J. Wysocki wrote:
> > On Tuesday, June 10, 2014 10:26:44 AM Dirk Brandewie wrote:
> >> On 06/10/2014 08:31 AM, Rafael J. Wysocki wrote:
> >>> On Tuesday, June 10, 2014 08:12:48 AM Dirk Brandewie wrote:
> >>>> On 06/09/2014 02:01 PM, Stratos Karafotis wrote:
> >>>>> Remove unnecessary blank lines.
> >>>>> Remove unnecessary parentheses.
> >>>>> Remove unnecessary braces.
> >>>>> Put the code in one line where possible.
> >>>>> Add blank lines after variable declarations.
> >>>>> Alignment to open parenthesis.
> >>>>>
> >>>>
> >>>> I don't have an issue with this patch in general but I would rather
> >>>> the cleanup be done when there is a functional change in the given
> >>>> hunk of code otherwise you are setting up a fence for stable/backporters
> >>>> of functional changes in the future.
> >>>
> >>> I actually prefer separate cleanups so as to avoid doing multiple things
> >>> in one patch.
> >>>
> >>> Rafael
> >>>
> >> I don't have strong feelings either way I was just trying to be kind
> >> to the maintainers of distro kernels.
> > 
> > And mixing fixes with cleanups in one patch doesn't do any good to them.
> > 
> > Trust me, I used to work for a distro. :-)
> > 
> 
> So, should I proceed and split the patch or drop it? :)

I'm not sure why you'd want to split it?

That said you're changing things that are intentional.  For example,
the

	if (acpi_disabled
	    || ...)

is.  And the result of (a * 100) / b may generally be different from
a * 100 / b for integers (if the division is carried out first).

Rafael

