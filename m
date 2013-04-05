Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161243Ab3DELre (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 07:47:34 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:51867 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161123Ab3DELrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 07:47:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
        Borislav Petkov <bp@alien8.de>, Jacob Shin <jacob.shin@amd.com>
Subject: Re: [PATCH V4 0/2] cpufreq: ondemand: add AMD specific powersave bias
Date: Fri, 05 Apr 2013 13:55:11 +0200
Message-ID: <2396755.WnKv3T7qE3@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohpo=OeNfJnmbqxP-+bG1ZZahk6kZ-AjcXn-zRQw24_6UG5g@mail.gmail.com>
References: <1365092344-11310-1-git-send-email-jacob.shin@amd.com> <CAKohpomhBtR2aONp=GsOUeaM1=8f2ZN7EfcGyc1NYZX=ZsweWA@mail.gmail.com> <CAKohpo=OeNfJnmbqxP-+bG1ZZahk6kZ-AjcXn-zRQw24_6UG5g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 05, 2013 12:19:36 PM Viresh Kumar wrote:
> On 5 April 2013 10:19, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> > For the latest versions sent by you (including {get|put}_online_cpus()):
> >
> > Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> 
> Hi Rafael,
> 
> I see that you have applied this patchset to bleeding-edge, but in
> wrong order. You have applied 2/2 first and then 1/2, which is
> wrong as after 2/2 we will have a compilation failure.

Ah, good catch.  I didn't notice that patchwork changed the ordering when
creating a bundle.

Should be fixed now.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
