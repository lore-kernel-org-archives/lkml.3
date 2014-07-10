Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbaGJLsj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 07:48:39 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37432 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752955AbaGJLsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 07:48:36 -0400
Date: Thu, 10 Jul 2014 13:48:28 +0200
From: Borislav Petkov <bp@alien8.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@rjwysocki.net, linaro-kernel@lists.linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        arvind.chauhan@arm.com
Subject: Re: [PATCH] cpufreq: report driver's successful {un}registration
Message-ID: <20140710114828.GA3254@pd.tnic>
References: <9e68cba2bf41923630ea93de7c3d17637f175895.1403772686.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9e68cba2bf41923630ea93de7c3d17637f175895.1403772686.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 02:21:30PM +0530, Viresh Kumar wrote:
> We do report driver's successful {un}registration from cpufreq core, but is done
> with pr_debug() and so this doesn't appear in boot logs.
> 
> Convert this to pr_info() to make it visible in logs.

And we want this because...?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
