Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbaGJOQN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 10:16:13 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34287 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbaGJOQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 10:16:11 -0400
Date: Thu, 10 Jul 2014 16:16:03 +0200
From: Borislav Petkov <bp@alien8.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>
Subject: Re: [PATCH] cpufreq: report driver's successful {un}registration
Message-ID: <20140710141603.GH2970@pd.tnic>
References: <9e68cba2bf41923630ea93de7c3d17637f175895.1403772686.git.viresh.kumar@linaro.org>
 <20140710114828.GA3254@pd.tnic>
 <CAKohpom0Qwbj5Ma_zCE5juk=1JjbBDLZJcBXZMgnkDVPiTvRCA@mail.gmail.com>
 <20140710115934.GF2970@pd.tnic>
 <CAKohpok0M1_khYB=AobfAuPM9Tf8wi63K5o6NCQ+sC=STP5HMw@mail.gmail.com>
 <20140710140704.GG2970@pd.tnic>
 <CAKohpok-ZdxJMCsLMGVA1yhmCjQyTwhCTu7PuXU47wpLQQyxEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAKohpok-ZdxJMCsLMGVA1yhmCjQyTwhCTu7PuXU47wpLQQyxEg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 07:43:07PM +0530, Viresh Kumar wrote:
> But I faced the issue when I had to see some test reports from the
> automated stuff and wanted to see if cpufreq is up and running.

Sorry, this is a very specialized usage to enforce meaningless spew in
dmesg on *everybody*. Fix your tests instead.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
