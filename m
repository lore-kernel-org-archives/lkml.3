Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbaEVEMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 00:12:42 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:62605 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbaEVEMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 00:12:41 -0400
MIME-Version: 1.0
In-Reply-To: <2173444.bOnmhZJafF@vostro.rjw.lan>
References: <60d825e8bfe01f8a5ff98fffaf51ffbf04c7d175.1400480033.git.viresh.kumar@linaro.org>
	<4765191.0FhyvSGyvF@vostro.rjw.lan>
	<CAKohpokaBo96h4axsntJz8b6q9VE7Z_GfQvfuQ85HEFi8r4V4w@mail.gmail.com>
	<2173444.bOnmhZJafF@vostro.rjw.lan>
Date: Thu, 22 May 2014 09:42:40 +0530
Message-ID: <CAKohpomoxh5vJUge5Jk5NGcDyWh_bMzLgwc4o02oUpZa4LJ2Mg@mail.gmail.com>
Subject: Re: [PATCH Resend] driver/core: cpu: initialize opp table
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Ips Gandhi <inderpal.s@samsung.com>, Pavel Machek <pavel@ucw.cz>,
        Nishanth Menon <nm@ti.com>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Shawn Guo <shawn.guo@linaro.org>,
        Sudeep Holla <sudeep.holla@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 May 2014 05:27, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> In a header file included by cpu.c.  Something like
>
> #if defined(CONFIG_OF) && defined(CONFIG_PM_OPP)
> <function header>
> #else
> static inline <stub>
> #endif

Thanks, Sudeep already helped me in understanding that :) ..
Already implemented that in cpu.c only ..
