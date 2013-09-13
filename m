Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113Ab3IMO2m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 10:28:42 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54598 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758014Ab3IMO2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 10:28:41 -0400
Date: Fri, 13 Sep 2013 15:27:29 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 038/228] cpufreq: sa11x0: Expose frequency table
Message-ID: <20130913142729.GU12758@n2100.arm.linux.org.uk>
References: <cover.1379063063.git.viresh.kumar@linaro.org> <e689bd437918e56ae50541a90a4b9c606bfb8bf4.1379063063.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e689bd437918e56ae50541a90a4b9c606bfb8bf4.1379063063.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 06:29:44PM +0530, Viresh Kumar wrote:
> This patch exposes sa11x0's frequency table to cpufreq core. It always existed
> but not as an array frequencies and not in the format cpufreq core wants it to.
> Also it was present in the unit of 100kHz earlier which is made consistent with
> cpufreq core now, i.e. kHz.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
