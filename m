Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbaAFBSk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 20:18:40 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:51662 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752383AbaAFBSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 20:18:39 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, linaro-kernel@lists.linaro.org,
        patches@linaro.org, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpufreq: arm-big-little: Make driver dependent on CONFIG_BIG_LITTLE
Date: Mon, 06 Jan 2014 02:32:24 +0100
Message-ID: <2100649.OqVGEpXy07@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc6+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <20140106011137.GE27432@n2100.arm.linux.org.uk>
References: <a76f7b6a290d9174a24e15b13df21f53e3f5655f.1388736624.git.viresh.kumar@linaro.org> <126282099.XSjqFqKQFW@vostro.rjw.lan> <20140106011137.GE27432@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 06, 2014 01:11:37 AM Russell King - ARM Linux wrote:
> On Mon, Jan 06, 2014 at 02:23:39AM +0100, Rafael J. Wysocki wrote:
> > On Monday, January 06, 2014 12:58:56 AM Russell King - ARM Linux wrote:
> > > On Mon, Jan 06, 2014 at 02:08:21AM +0100, Rafael J. Wysocki wrote:
> > > > On Friday, January 03, 2014 03:51:39 PM Viresh Kumar wrote:
> > > > > arm_big_little cpufreq driver is only used for ARM bigLITTLE platforms and hence
> > > > > must be dependent on CONFIG_BIG_LITTLE.
> > > > > 
> > > > > This was highlighted by Russell earlier when he reported this issue:
> > > > > 
> > > > > drivers/built-in.o: In function `bL_cpufreq_set_rate':
> > > > > powercap_sys.c:(.text+0x5ed9a0): undefined reference to `bL_switch_request_cb'
> > > > > 
> > > > > Reported-by: Russell King <linux@arm.linux.org.uk>
> > > > > Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> > > > 
> > > > Queued up for 3.14, thanks!
> > > 
> > > This is actually a build fix, not a new feature, so IMHO it should go
> > > in for 3.13.  Linus has said he's going to do -rc8 anyway next weekend
> > > so -final is at the earliest two weeks away.
> > 
> > Well, it can go into 3.13 too.
> > 
> > Thanks!
> 
> Thanks.

Well, actually, I was wrong.  It depends on stuff already queued up for 3.14,
so either I'd need to drag all that into 3.13, or it needs to wait for 3.14.

So it will wait, sorry about that.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
