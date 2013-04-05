Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161702Ab3DEGti (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 02:49:38 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:43769 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161597Ab3DEGtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 02:49:36 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpomhBtR2aONp=GsOUeaM1=8f2ZN7EfcGyc1NYZX=ZsweWA@mail.gmail.com>
References: <1365092344-11310-1-git-send-email-jacob.shin@amd.com>
	<CAKohpomhBtR2aONp=GsOUeaM1=8f2ZN7EfcGyc1NYZX=ZsweWA@mail.gmail.com>
Date: Fri, 5 Apr 2013 12:19:36 +0530
Message-ID: <CAKohpo=OeNfJnmbqxP-+bG1ZZahk6kZ-AjcXn-zRQw24_6UG5g@mail.gmail.com>
Subject: Re: [PATCH V4 0/2] cpufreq: ondemand: add AMD specific powersave bias
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
        Borislav Petkov <bp@alien8.de>, Jacob Shin <jacob.shin@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 April 2013 10:19, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> For the latest versions sent by you (including {get|put}_online_cpus()):
>
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

Hi Rafael,

I see that you have applied this patchset to bleeding-edge, but in
wrong order. You have applied 2/2 first and then 1/2, which is
wrong as after 2/2 we will have a compilation failure.
