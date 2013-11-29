Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312Ab3K2KHr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 05:07:47 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:57214 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931Ab3K2KHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 05:07:45 -0500
MIME-Version: 1.0
In-Reply-To: <1415633.hVIJGiCZ0n@vostro.rjw.lan>
References: <ad0a09012f3621024deb51120c3d4ef97ffcbd0f.1385649767.git.viresh.kumar@linaro.org>
	<1415633.hVIJGiCZ0n@vostro.rjw.lan>
Date: Fri, 29 Nov 2013 15:37:45 +0530
Message-ID: <CAKohpok1Y6kwtkaPSABcX6x4J6d-jCcxS0kE6zojNH7pDT710w@mail.gmail.com>
Subject: Re: [PATCH V3] cpufreq: Make sure CPU is running on a freq from freq-table
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>, Carlos Hernandez <ceh@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 November 2013 02:16, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> Well, this looks more and more complicated from version to version ...

:)

> Overall, this looks like code written in a hurry.  Please avoid doing that.

Thanks for all the tips, I will take care of this stuff in future.
