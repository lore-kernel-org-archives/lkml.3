Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254AbaJBLzP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 07:55:15 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:58791 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751208AbaJBLzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 07:55:14 -0400
Message-ID: <1412250911.3060.13.camel@x41>
Subject: Re: cpufreq v3.17-rc7 error: "cpufreq: cpufreq_resume: Failed to
 start governor for policy: f6909a00"
From: Paul Bolle <pebolle@tiscali.nl>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 02 Oct 2014 13:55:11 +0200
In-Reply-To: <1412250350.3060.9.camel@x41>
References: <1412250350.3060.9.camel@x41>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Oct 2014 11:55:12.0033 (UTC) FILETIME=[B8B2D910:01CFDE37]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Bolle schreef op do 02-10-2014 om 13:45 [+0200]:
> Running v3.17-rc7 I see a new (for me) error, apparently during each
> resume (from suspend) or thaw (from hibernate):
>      cpufreq: cpufreq_resume: Failed to start governor for policy: f6909a00

So there are only two recent commits:
    7106e02baed4 ("cpufreq: release policy->rwsem on error")
    8e30444e1530 ("cpufreq: fix cpufreq suspend/resume for
        intel_pstate")

Would it be useful to test whether reverting the oldest commit,
8e30444e1530 ("cpufreq: fix cpufreq suspend/resume for intel_pstate"),
changes anything?


Paul Bolle

