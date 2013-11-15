Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757159Ab3KOEkF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 23:40:05 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:34015 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756993Ab3KOEkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 23:40:03 -0500
Message-ID: <5285A59C.2070603@linaro.org>
Date: Fri, 15 Nov 2013 10:09:56 +0530
From: viresh kumar <viresh.kumar@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Nishanth Menon <nm@ti.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [RFC PATCH] cpufreq: cpufreq-cpu0: do not allow transitions with
 regulators suspended
References: <1382638087-32054-1-git-send-email-nm@ti.com> <20131113151645.GA17828@kahuna> <52842671.40703@linaro.org> <2085822.gaTNcUz76n@vostro.rjw.lan>
In-Reply-To: <2085822.gaTNcUz76n@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 November 2013 03:30 AM, Rafael J. Wysocki wrote:
> I'm not going to apply anything like this.  If I have already, that's been a mistake.
> 
> Do not mix assignments with logical operators in such outrageous ways, please.
> That's completely unreadable and confusing.

Okay... Will get it fixed for existing code as well..
