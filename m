Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab3KOPex (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 10:34:53 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:57800 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab3KOPep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 10:34:45 -0500
MIME-Version: 1.0
In-Reply-To: <52862648.4000304@ti.com>
References: <0e476d16e0ae4b001f5dd4f9ac191f899095928a.1384510171.git.viresh.kumar@linaro.org>
	<52862648.4000304@ti.com>
Date: Fri, 15 Nov 2013 21:04:45 +0530
Message-ID: <CAKohpokDFr4=XPAwG1g75g=0iHHCEgpHYtSv4hbvfOFfEZRewg@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: suspend/resume governors with PM notifiers
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Nishanth Menon <nm@ti.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lan Tianyu <tianyu.lan@intel.com>, jinchoi@broadcom.com,
        Sebastian Capella <sebastian.capella@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 November 2013 19:18, Nishanth Menon <nm@ti.com> wrote:
> Yes, this does fix the issue for me.
>
> Tested-by: Nishanth Menon <nm@ti.com>
> based on vendor kernel on top of v3.12 tag (equivalent diff:
> http://pastebin.mozilla.org/3609407)
>
> OMAP5-uEVM(OMAP5432): http://pastebin.mozilla.org/3609396

Thanks a lot for verifying buddy!! Glad that your issue is fixed..
