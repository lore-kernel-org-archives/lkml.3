Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab3GOGRW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 02:17:22 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:35192 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749Ab3GOGRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 02:17:20 -0400
Message-ID: <51E39314.6060808@linux.vnet.ibm.com>
Date: Mon, 15 Jul 2013 11:43:40 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>, cpufreq@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpufreq: Fix cpufreq regression after suspend/resume
References: <51C08370.4050906@gmx.de> <CAKohpok1gThXL925Yz5UgC54vTVQgymBA1cLGER_g-dgZu0JLA@mail.gmail.com> <51CF1E53.6060902@gmx.de> <8029836.CFiJCXmRQ0@vostro.rjw.lan> <51D05DF4.50704@linux.vnet.ibm.com> <51D06556.7080204@gmx.de> <51D07E7F.2030709@linux.vnet.ibm.com> <51DDC8FA.4020609@gmx.de> <1373710596.1352.26.camel@x61.thuisdomein> <1373719972.1359.8.camel@x61.thuisdomein>
In-Reply-To: <1373719972.1359.8.camel@x61.thuisdomein>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071506-8256-0000-0000-000008567136
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2013 06:22 PM, Paul Bolle wrote:
> On Sat, 2013-07-13 at 12:16 +0200, Paul Bolle wrote:
>> I suspect that the stuck frequency is a regression introduced in v3.10.0.
> 
> The culprit apparently is commit a66b2e503f ("cpufreq: Preserve sysfs
> files across suspend/resume"). Srivatsa submitted a patch to revert that
> commit (see https://lkml.org/lkml/2013/7/11/661 ). That revert seems to
> fix this issue too.
> 
>

Thanks a lot for your tests and for confirming that the complete revert
fixes your cpufreq issue.
 
 
Regards,
Srivatsa S. Bhat

