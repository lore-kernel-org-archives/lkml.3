Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab3AaSuY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 13:50:24 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:59620 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab3AaSuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 13:50:22 -0500
Date: Thu, 31 Jan 2013 19:50:04 +0100
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com
Subject: Re: [PATCH 2/2] cpufreq: governors: Remove code redundancy between
 governors
Message-ID: <20130131185004.GB20164@balto.lan>
References: <09a94ff044ff6a6f7a5d953c3b1f3102c1dc50cf.1359653181.git.viresh.kumar@linaro.org>
 <118c59263751862b1750ed9f96639a4e70069e66.1359653181.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <118c59263751862b1750ed9f96639a4e70069e66.1359653181.git.viresh.kumar@linaro.org>
X-Operating-System: Linux balto 3.8.0-rc3-00668-g55706d3 x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 10:58:02PM +0530, Viresh Kumar wrote:
> With the inclusion of following patches:
> 
> 9f4eb10 cpufreq: conservative: call dbs_check_cpu only when necessary
> 772b4b1 cpufreq: ondemand: call dbs_check_cpu only when necessary
> 
> code redundancy is introduced again. Get rid of it.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---

Hi,

Tested-by: Fabio Baltieri <fabio.baltieri@linaro.org>

Thanks,
Fabio

-- 
Fabio Baltieri
