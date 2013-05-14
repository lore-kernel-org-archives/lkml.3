Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411Ab3ENMw2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 08:52:28 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:45843 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756770Ab3ENMw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 08:52:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: "'Viresh Kumar'" <viresh.kumar@linaro.org>, robin.randhawa@arm.com,
        "'Ben Dooks'" <ben-linux@fluff.org>, linux-pm@vger.kernel.org,
        patches@linaro.org, Liviu.Dudau@arm.com, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Steve.Bannister@arm.com,
        arvind.chauhan@arm.com, linaro-kernel@lists.linaro.org,
        charles.garcia-tobin@arm.com
Subject: Re: [PATCH 07/18] cpufreq: s3c24xx: move cpufreq driver to drivers/cpufreq
Date: Tue, 14 May 2013 15:00:59 +0200
Message-ID: <2001452.Fn2HjLbNED@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <093901ce509f$afe92f40$0fbb8dc0$%kim@samsung.com>
References: <cover.1365079581.git.viresh.kumar@linaro.org> <CAKohponkFB7ND38jv5oGnQLx8cq0b=uHTCmL3EERe6P54ijYhw@mail.gmail.com> <093901ce509f$afe92f40$0fbb8dc0$%kim@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 14, 2013 09:36:42 PM Kukjin Kim wrote:
> Viresh Kumar wrote:
> > 
> > On 13 May 2013 16:21, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > That doesn't matter I suppose.  I can take it, but please rebase it on
> > top
> > > of current linux-next.
> > 
> > I have already done that (attached). But i wasn't sure what Kukjin wants
> > as
> > he may report conflicts again and i will ask the same question for 3.12 :)
> > 
> Since this missed last time, this would be sent to upstream via samsung tree
> again. It means the conflicts should be handled by myself.
> 
> Rafael, if you don't mind, let me take this into Samsung tree for v3.11.

Sure, please go ahead.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
