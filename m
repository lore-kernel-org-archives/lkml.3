Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965605Ab3E2KrG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 06:47:06 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:55558 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965388Ab3E2KrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 06:47:04 -0400
Message-ID: <1369824422.22004.101.camel@joe-AO722>
Subject: Re: [PATCH] cpufreq: MAINTAINERS: Add git tree path for ARM
 specific updates
From: Joe Perches <joe@perches.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        linux-arm-kernel@lists.infradead.org
Date: Wed, 29 May 2013 03:47:02 -0700
In-Reply-To: <aab5b5dc92b960e81e8fd1975eba81234a4ecac8.1369817795.git.viresh.kumar@linaro.org>
References: <aab5b5dc92b960e81e8fd1975eba81234a4ecac8.1369817795.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-29 at 16:10 +0530, Viresh Kumar wrote:
> ARM specific patches would be
> Applied by me now. Rafael will pull in these changes from time to time (at
> rc's).
[]
> diff --git a/MAINTAINERS b/MAINTAINERS
[]
> @@ -2216,6 +2216,7 @@ L:	cpufreq@vger.kernel.org
[]
>  T:	git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git
> +T:	git://git.linaro.org/people/vireshk/linux.git (For ARM Updates)

please prefix these with git

T:	git git://git.etc...

Every other T: git entry does.

