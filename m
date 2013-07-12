Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303Ab3GLHT0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 03:19:26 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:41983 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757226Ab3GLHTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 03:19:22 -0400
MIME-Version: 1.0
In-Reply-To: <20130711221644.547.74786.stgit@srivatsabhat.in.ibm.com>
References: <20130711221419.547.69781.stgit@srivatsabhat.in.ibm.com>
	<20130711221644.547.74786.stgit@srivatsabhat.in.ibm.com>
Date: Fri, 12 Jul 2013 12:49:21 +0530
Message-ID: <CAKohpo=eo5KAjE6Nk32aLJ3-KZZ4Ge-mm+hB1-gUMk+ZDF8iqw@mail.gmail.com>
Subject: Re: [PATCH 5/8] cpufreq: Extract the handover of policy cpu to a
 helper function
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

On 12 July 2013 03:46, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> During cpu offline, when the policy->cpu is going down, some other CPU
> present in the policy->cpus mask is nominated as the new policy->cpu.
> Extract this functionality from __cpufreq_remove_dev() and implement
> it in a helper function. This helps in upcoming code reorganization.
>
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---
>
>  drivers/cpufreq/cpufreq.c |   62 ++++++++++++++++++++++++++++-----------------
>  1 file changed, 38 insertions(+), 24 deletions(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
