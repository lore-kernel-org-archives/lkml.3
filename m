Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933420Ab3CMVM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 17:12:27 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:52990 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755231Ab3CMVM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 17:12:26 -0400
Message-ID: <1363209145.1335.14.camel@x61.thuisdomein>
Subject: Re: [PATCH] PM: devfreq: fix typo "CPU_EXYNOS4.12" twice
From: Paul Bolle <pebolle@tiscali.nl>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 13 Mar 2013 22:12:25 +0100
In-Reply-To: <1363209002.1335.12.camel@x61.thuisdomein>
References: <1363209002.1335.12.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Mar 2013 21:12:25.0613 (UTC) FILETIME=[76084BD0:01CE202F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-13 at 22:10 +0100, Paul Bolle wrote:
> Dependencies on CPU_EXYNOS4212 and CPU_EXYNOS4412 for the "ARM
> Exynos4210/4212/4412 Memory Bus DEVFREQ Driver" were added in commit
> 7b4050381127ae11fcfc74a106d715a5fbbf888a ("PM/Devfreq: Add Exynos4-bus
> device DVFS driver for Exynos4210/4212/4412."). The tree (at that time,
> v3.3, and currently) makes clear that this should have been dependencies
> on SOC_EXYNOS4212 and SOC_EXYNOS4412.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---

Forgot to add that this is untested: no access to hardware, etc.


Paul Bolle

