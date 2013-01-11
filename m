Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836Ab3AKWFx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 17:05:53 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:38197 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754674Ab3AKWFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 17:05:52 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Shawn Guo <shawn.guo@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>,
        linux-pm@vger.kernel.org
Cc: robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpufreq: Simplify __cpufreq_remove_dev()
Date: Fri, 11 Jan 2013 23:11:38 +0100
Message-ID: <9372306.uEln1VHseC@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAAQ0ZWTvKcn5qR8_J5hx+qsxHGTJ8rSE41VD6aQhipM6c+CqTA@mail.gmail.com>
References: <aa10abe640afed8700abf262dbfc9b9c22659b6a.1357729671.git.viresh.kumar@linaro.org> <CAKohpone-pXUjuDsP7r73mP+rzSUUb1oWiu5c+NL8R_WsYoJZg@mail.gmail.com> <CAAQ0ZWTvKcn5qR8_J5hx+qsxHGTJ8rSE41VD6aQhipM6c+CqTA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 10, 2013 04:10:55 PM Shawn Guo wrote:
> On 10 January 2013 16:05, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> > Another thing, can i have a tested-by from you for both my patches ? remove and
> > add dev?
> >
> For both:
> 
> Tested-by: Shawn Guo <shawn.guo@linaro.org>

OK

Can any one of you two create a series of patches for me to take for v3.9
with all of the correct Tested-by and Reviewed-by etc. tags, because I've
already lost track of your multiple versions and threads?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
