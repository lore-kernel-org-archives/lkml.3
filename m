Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab3KVMss (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 07:48:48 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:53645 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab3KVMsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 07:48:47 -0500
MIME-Version: 1.0
In-Reply-To: <230872262.gyF1HmIKoj@vostro.rjw.lan>
References: <cover.1385118255.git.viresh.kumar@linaro.org>
	<e4bc55fac6bc68694e9905cc3cc6844173b64925.1385118256.git.viresh.kumar@linaro.org>
	<230872262.gyF1HmIKoj@vostro.rjw.lan>
Date: Fri, 22 Nov 2013 18:18:46 +0530
Message-ID: <CAKohpomaRUBL8HP-LVyN-E9w_rb9c9StW4xaR+kormfjskw_CA@mail.gmail.com>
Subject: Re: [PATCH V2 1/2] cpufreq: suspend governors on system suspend/hibernate
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lan Tianyu <tianyu.lan@intel.com>, Nishanth Menon <nm@ti.com>,
        jinchoi@broadcom.com, Sebastian Capella <sebastian.capella@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 November 2013 18:03, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> The locking here is pointless.  It doesn't prevent any race conditions
> from happening.

All comments accepted..
