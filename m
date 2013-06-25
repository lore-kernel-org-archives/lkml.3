Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727Ab3FYGot (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 02:44:49 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43712 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab3FYGor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 02:44:47 -0400
MIME-Version: 1.0
In-Reply-To: <1372133724.1245.38.camel@joe-AO722>
References: <1372102237-8757-1-git-send-email-paul.gortmaker@windriver.com>
	<1372102237-8757-26-git-send-email-paul.gortmaker@windriver.com>
	<CAKohponpsJBqbj_8u8MUiu7sCEpeg5bcztWJAZdn9uxL5taVZQ@mail.gmail.com>
	<1372133724.1245.38.camel@joe-AO722>
Date: Tue, 25 Jun 2013 12:14:46 +0530
Message-ID: <CAKohpomOyV2zze1QCKArytXD=x7NXSPtsxped_j2ZKJ_aZOi3w@mail.gmail.com>
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

On 25 June 2013 09:45, Joe Perches <joe@perches.com> wrote:
> Viresh, there's no absolute "right" way to do this.

Yeah Joe, but I thought its better to keep it consistent within a file.
So, while writing new files, keep what you want but for existing ones
follow what's in there.
