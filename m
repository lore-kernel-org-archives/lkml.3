Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933063Ab3IMO3r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 10:29:47 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54604 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932900Ab3IMO3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 10:29:45 -0400
Date: Fri, 13 Sep 2013 15:29:37 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 039/228] cpufreq: sa11x0: let cpufreq core initialize
	struct policy fields
Message-ID: <20130913142937.GV12758@n2100.arm.linux.org.uk>
References: <cover.1379063063.git.viresh.kumar@linaro.org> <8a36f8e32d7a9e9f4aa74db0525dbdc74fc023dd.1379063063.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8a36f8e32d7a9e9f4aa74db0525dbdc74fc023dd.1379063063.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 06:29:45PM +0530, Viresh Kumar wrote:
> Many fields of struct policy are filled by cpufreq core when we call
> cpufreq_table_validate_and_show() and so cpufreq driver doesn't need to set them
> anymore.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
