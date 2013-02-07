Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758004Ab3BGKmt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 05:42:49 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:63468 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757316Ab3BGKmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 05:42:44 -0500
MIME-Version: 1.0
In-Reply-To: <1360170133-5066-1-git-send-email-dirk.brandewie@gmail.com>
References: <1360170133-5066-1-git-send-email-dirk.brandewie@gmail.com>
Date: Thu, 7 Feb 2013 16:12:42 +0530
X-Google-Sender-Auth: nO-dFzIUsk2MFptW-9MPLBnSlzw
Message-ID: <CAOh2x==-u_AuyG34t0cg6BURsj3rU4rwSgZaSbX4ULU7ztdxMg@mail.gmail.com>
Subject: Re: [PATCH 0/5] Add P state driver for Intel Core Processors
From: Viresh Kumar <viresh.kumar@linaro.org>
To: dirk.brandewie@gmail.com, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        Amit Kucheria <amit.kucheria@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 6, 2013 at 10:32 PM,  <dirk.brandewie@gmail.com> wrote:
> From: Dirk Brandewie <dirk.brandewie@gmail.com>
>
> This driver implements a scaling driver with an internal governor for
> Intel Core processors.  The driver follows the same model as the
> Transmeta scaling driver (longrun.c) and implements the setpolicy()
> instead of target().  Scaling drivers that implement setpolicy() are
> assmuned to implement internal governors by the cpufreq core. All the
> logic for selecting the current P state is contained within the driver
> no external governor is used by the cpufreq core.

Hi Dirk,

All look good now :)
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

@Rafael: I wasn't sure if these would apply over my patches without any
conflicts and so i applied them in my repo. Added my Acked-by's and fixed
a minor thing in one of the patches (as mentioned in the other mail).

You can pick these from: dirk-patches

http://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=shortlog;h=refs/heads/dirk-patches
