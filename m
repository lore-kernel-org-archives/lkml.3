Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861AbaDGRdP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 13:33:15 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:19520 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755767AbaDGRc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 13:32:26 -0400
Date: Mon, 7 Apr 2014 18:31:50 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>
Subject: Re: [PATCH] ARM64: Remove duplicated Kconfig entry for
 "kernel/power/Kconfig"
Message-ID: <20140407173149.GF8479@arm.com>
References: <1396523809-6945-1-git-send-email-hanjun.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396523809-6945-1-git-send-email-hanjun.guo@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2014 at 12:16:49PM +0100, Hanjun Guo wrote:
> There is a duplicated Kconfig entry for "kernel/power/Kconfig"
> in menu "Power management options" and "CPU Power Management",
> remove the one from menu "CPU Power Management" suggested by
> Viresh.
> 
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>

Thanks. I'll push this after -rc1 (to use a more stable base for my
tree).

-- 
Catalin
