Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178AbaESXIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 19:08:13 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:60237 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751103AbaESXIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 19:08:12 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Stephen Warren <swarren@nvidia.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>
Subject: Re: [PATCH] cpufreq: Tegra: drop wrapper around tegra_update_cpu_speed()
Date: Tue, 20 May 2014 01:25:06 +0200
Message-ID: <7390169.l9Y1Z45IAv@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAKohponB_wiJZ9jq+JrJGxe7Y-447FpEjSZRZ+snXpxmOP=Erg@mail.gmail.com>
References: <a38df05b91198f393b1c4b78f39110c6bece3627.1400133049.git.viresh.kumar@linaro.org> <53750B27.4020708@wwwdotorg.org> <CAKohponB_wiJZ9jq+JrJGxe7Y-447FpEjSZRZ+snXpxmOP=Erg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 16, 2014 11:36:48 AM Viresh Kumar wrote:
> On 16 May 2014 00:14, Stephen Warren <swarren@wwwdotorg.org> wrote:
> > On 05/14/2014 11:51 PM, Viresh Kumar wrote:
> >> Tegra has implemented an unnecessary wrapper over tegra_update_cpu_speed(), i.e.
> >> tegra_target(), which wasn't doing anything apart of calling
> >> tegra_update_cpu_speed(). Get rid of that and use tegra_target() directly.
> >
> > I think it used to do something until some refactoring happened? Anyway,
> 
> Yep..
> 
> > Acked-by: Stephen Warren <swarren@nvidia.com>

Patch queued up for 3.16, thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
