Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873Ab3BEVy3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 16:54:29 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:47641 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756737Ab3BEVy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 16:54:26 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>
Subject: Re: [PATCH 0/2] cpufreq: cpufreq_driver_lock is hot on large systems
Date: Tue, 05 Feb 2013 23:00:44 +0100
Message-ID: <4042917.3aPiiW9y2F@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc6; KDE/4.9.5; x86_64; ; )
In-Reply-To: <74F10842A85F514CA8D8C487E74474BB2D2F925E@P-EXMB1-DC21.corp.sgi.com>
References: <1360017913-25667-1-git-send-email-nzimmer@sgi.com> <1535355.NvOsIhbBYp@vostro.rjw.lan> <74F10842A85F514CA8D8C487E74474BB2D2F925E@P-EXMB1-DC21.corp.sgi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 05, 2013 02:58:35 PM Nathan Zimmer wrote:
> Ok, I'll rebase and retest from linux-next then.

Thanks!


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
