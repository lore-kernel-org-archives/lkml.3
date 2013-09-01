Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584Ab3IANSc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 09:18:32 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:49734 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191Ab3IANSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 09:18:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] cpufreq: don't allow governor limits to be changed when it is disabled
Date: Sun, 01 Sep 2013 15:29:20 +0200
Message-ID: <8685493.XaYGerLxqW@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0-rc7+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAKohpomt4vAxHiCkiSzpX6UttMqox=Sc9Oqhgxw6YHtkJfghGQ@mail.gmail.com>
References: <085013f4e584e3fef97187bcb349c3fa76942e19.1378012620.git.viresh.kumar@linaro.org> <CAKohpomt4vAxHiCkiSzpX6UttMqox=Sc9Oqhgxw6YHtkJfghGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, September 01, 2013 11:56:09 AM Viresh Kumar wrote:
> On 1 September 2013 10:56, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> > Its better if we can get these in for 3.11, otherwise we need to get them in the
> > stable tree..
> 
> They can't get into 3.11 due to two reasons..
> - I haven't tested them over 3.11 but linux-next/master.
> - Few more dependency patches might also be required for 3.11..
> 
> So get them into 3.12-rc1 if they look okay to you :)

I'm going to do that, but please add explanation to the [2/2] changelog.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
