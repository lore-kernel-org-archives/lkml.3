Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881Ab3FYHBq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 03:01:46 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:48075 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab3FYHBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 03:01:44 -0400
MIME-Version: 1.0
In-Reply-To: <1372143585.1245.44.camel@joe-AO722>
References: <1372102237-8757-1-git-send-email-paul.gortmaker@windriver.com>
	<1372102237-8757-26-git-send-email-paul.gortmaker@windriver.com>
	<CAKohponpsJBqbj_8u8MUiu7sCEpeg5bcztWJAZdn9uxL5taVZQ@mail.gmail.com>
	<1372133724.1245.38.camel@joe-AO722>
	<CAKohpomOyV2zze1QCKArytXD=x7NXSPtsxped_j2ZKJ_aZOi3w@mail.gmail.com>
	<1372143585.1245.44.camel@joe-AO722>
Date: Tue, 25 Jun 2013 12:31:43 +0530
Message-ID: <CAKohpokbXbyLpqd=XWy3iEqx-=AA=QEH_GyxOeaKFTw34tuwuQ@mail.gmail.com>
Subject: Re: [PATCH 25/32] cpufreq: delete __cpuinit usage from all cpufreq files
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Joe Perches <joe@perches.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 June 2013 12:29, Joe Perches <joe@perches.com> wrote:
> Sure Viresh.
>
> I could agree with that, but that's not what you
> recommended though.  "Check this everywhere" isn't
> the same as the advice you just gave above.

So, I couldn't communicate myself well :(
What I meant is, "check all changes you are making
and be sure you are not repeating this change again".
