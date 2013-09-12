Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977Ab3ILKIM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 06:08:12 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:45039 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab3ILKIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 06:08:10 -0400
MIME-Version: 1.0
In-Reply-To: <52317849.90101@linux.vnet.ibm.com>
References: <cover.1378963070.git.viresh.kumar@linaro.org>
	<22f0d94203b9e3d29f123c0e80df4b012e01dbb5.1378963070.git.viresh.kumar@linaro.org>
	<52317849.90101@linux.vnet.ibm.com>
Date: Thu, 12 Sep 2013 15:38:09 +0530
Message-ID: <CAKohpomLNz2Sac1ZqiQS8yW+q13UWhu4dT+vkfLe2TGXG4+iUw@mail.gmail.com>
Subject: Re: [PATCH 1/5] cpufreq: Remove extra blank line
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Stephen Warren <swarren@wwwdotorg.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 September 2013 13:46, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> Well, I felt having that line avoids clutter, especially since the code
> around it was already a bit hard to read..

Well, its exact opposite for me.. somehow my attending keeps dragging
to extra blank lines :)

> Anyway, I don't have any strong opinions either way. So no objections
> from my side. (But you might have to rebase this patch on top of Rafael's
> tree, due to the recent changes he pushed in to this code).

I tried a rebase and couldn't find a issue.. And so not resending the series.
