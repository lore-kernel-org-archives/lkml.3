Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146Ab3G3JKC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:10:02 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:64086 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758375Ab3G3JJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:09:59 -0400
MIME-Version: 1.0
In-Reply-To: <20130729225519.20863.61030.stgit@srivatsabhat.in.ibm.com>
References: <20130729225213.20863.56722.stgit@srivatsabhat.in.ibm.com>
	<20130729225519.20863.61030.stgit@srivatsabhat.in.ibm.com>
Date: Tue, 30 Jul 2013 14:39:58 +0530
Message-ID: <CAKohpokQB9T2CPzgMEiPrAuZvCMf9srWsdGmtKtkDgz52YoihA@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] cpufreq: Perform light-weight init/teardown during suspend/resume
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: rjw@sisk.pl, toralf.foerster@gmx.de, robert.jarzmik@intel.com,
        durgadoss.r@intel.com, tianyu.lan@intel.com, lantianyu1986@gmail.com,
        dirk.brandewie@gmail.com, stern@rowland.harvard.edu,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 July 2013 04:25, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> Now that we have the infrastructure to perform a light-weight init/tear-down,
> use that in the cpufreq CPU hotplug notifier when invoked from the
> suspend/resume path.
>
> This also ensures that the file permissions of the cpufreq sysfs files are
> preserved across suspend/resume, something which commit a66b2e (cpufreq:
> Preserve sysfs files across suspend/resume) originally intended to do, but
> had to be reverted due to other problems.
>
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
