Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbaEVGli (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 02:41:38 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:54103 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751184AbaEVGlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 02:41:37 -0400
Message-ID: <1400740894.21254.8.camel@x220>
Subject: Re: [PATCH] cpufreq: s5pv210: remove unused call of pr_err()
From: Paul Bolle <pebolle@tiscali.nl>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 22 May 2014 08:41:34 +0200
In-Reply-To: <CAK9yfHz2kdfkf+o7fKMRu=nMXxbcHJ227bjpvA=WXt6ptH3QRA@mail.gmail.com>
References: <1400702036.30334.6.camel@x220>
	 <CAK9yfHz2kdfkf+o7fKMRu=nMXxbcHJ227bjpvA=WXt6ptH3QRA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 May 2014 06:41:35.0044 (UTC) FILETIME=[DFF57040:01CF7588]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sachin,

On Thu, 2014-05-22 at 08:52 +0530, Sachin Kamat wrote:
> The config symbol itself is not defined and hence could be removed.
> However I feel, the
> error message could be retained after trimming down the arguments a bit.

My reasoning is, of course, that never used code can simply be dropped.

But you want to print an error here. That's fine with me. I prefer if
you'd submit a patch that does that, as I have no idea whatsoever why an
error is needed here nor what that error should say.

I do hope you don't mind me prodding you if that takes too long, and
this pointless check of CONFIG_PM_VERBOSE is still here after, say,
another development cycle.


Paul Bolle

