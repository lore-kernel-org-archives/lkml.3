Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828AbaESU71 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 16:59:27 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:65502 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751046AbaESU7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 16:59:25 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        inderpal.s@samsung.com, pavel@ucw.cz, nm@ti.com,
        chander.kashyap@linaro.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Shawn Guo <shawn.guo@linaro.org>,
        Sudeep Holla <sudeep.holla@arm.com>
Subject: Re: [PATCH Resend] driver/core: cpu: initialize opp table
Date: Mon, 19 May 2014 23:16:20 +0200
Message-ID: <1458497.gJ29RmexAd@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <4765191.0FhyvSGyvF@vostro.rjw.lan>
References: <60d825e8bfe01f8a5ff98fffaf51ffbf04c7d175.1400480033.git.viresh.kumar@linaro.org> <ca7cc76c49806ce1ac8f9617fa4266cfc29d1ea1.1400480592.git.viresh.kumar@linaro.org> <4765191.0FhyvSGyvF@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 19, 2014 11:13:24 PM Rafael J. Wysocki wrote:
> On Monday, May 19, 2014 11:59:11 AM Viresh Kumar wrote:
> > All drivers expecting CPU's OPPs from device tree initialize OPP table using
> > of_init_opp_table() and there is nothing driver specific in that. They all do it
> > in the same way adding to code redundancy.
> > 
> > It would be better if we can get rid of code redundancy by initializing CPU OPPs
> > from core code for all CPUs that have a "operating-points" property defined in
> > their node.
> > 
> > This patch initializes OPPs as soon as CPU device is registered in
> > register_cpu().
> > 
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
> > Cc: Kukjin Kim <kgene.kim@samsung.com>
> > Cc: Shawn Guo <shawn.guo@linaro.org>
> > Cc: Sudeep Holla <sudeep.holla@arm.com>
> > Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Do patches [2-5/5] depend on this one BTW?

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
