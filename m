Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266Ab3GLHbV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 03:31:21 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:61558 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757201Ab3GLHbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 03:31:19 -0400
MIME-Version: 1.0
In-Reply-To: <20130711221657.547.2293.stgit@srivatsabhat.in.ibm.com>
References: <20130711221419.547.69781.stgit@srivatsabhat.in.ibm.com>
	<20130711221657.547.2293.stgit@srivatsabhat.in.ibm.com>
Date: Fri, 12 Jul 2013 13:01:19 +0530
Message-ID: <CAKohpokfvdX41XGmTY0bxKUJ5adx3Hu6gESJ+Xq+gEuRYrjBgw@mail.gmail.com>
Subject: Re: [PATCH 6/8] cpufreq: Introduce a flag ('frozen') to separate full
 vs temporary init/teardown
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
> During suspend/resume we would like to do a light-weight init/teardown of
> CPUs in the cpufreq subsystem and preserve certain things such as sysfs files
> etc across suspend/resume transitions. Add a flag called 'frozen' to help
> distinguish the full init/teardown sequence from the light-weight one.
>
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---
>
>  drivers/cpufreq/cpufreq.c |   66 ++++++++++++++++++++++++++++-----------------
>  1 file changed, 41 insertions(+), 25 deletions(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
