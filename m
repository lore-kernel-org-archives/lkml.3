Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbaBTPBJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 10:01:09 -0500
Received: from mail.skyhub.de ([78.46.96.112]:50784 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753124AbaBTPBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 10:01:06 -0500
Date: Thu, 20 Feb 2014 16:01:01 +0100
From: Borislav Petkov <bp@alien8.de>
To: Otto Meier <gf435@gmx.net>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [3.14-rc3] possible regression Haswell runs only at 770Mhz with
 powersave governor
Message-ID: <20140220150101.GA9557@pd.tnic>
References: <53061204.7080700@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53061204.7080700@gmx.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add lists to CC.

On Thu, Feb 20, 2014 at 03:32:36PM +0100, Otto Meier wrote:
> Hello,
> 
> My System which runs with older kernels up to 3.13.3
> fine on my i3-4330 with 3.5 Ghz and governor powersave.
> and pstate driver.
> 
> With kernel 3.14-rc3 and Governor powersave it runs
> only at 770Mhz and never switches to higher Freq. on load.
> Even compiling a kernel with make -j4   does not change freq.
> 
> With governor performance  it switches to 3.5 Ghz and stays
> there.
> 
> Any Idea how to fix this?
> 
> Best regards

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
