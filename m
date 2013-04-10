Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936137Ab3DJHl6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 03:41:58 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:48872 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab3DJHl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 03:41:57 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Wed, 10 Apr 2013 09:41:55 +0200
Message-ID: <CA+icZUU=SdiaPBqabf0miOM1Arsc=PjHQbY4GpaDiM4=Fbp73A@mail.gmail.com>
Subject: Re: [RFC PATCH] kbuild: Build linux-tools package with 'make deb-pkg'
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Ben Hutchings <ben@decadent.org.uk>, debian-kernel@lists.debian.org,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        cpufreq@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ CCing some involved maintainers and MLs ]

Hi Joerg,

what is the status of your proposal patch?
Is this [1] the last version you posted?

What's with the integration into linux-kbuild?

Background of my asking is that I need to build cpufreq-info shipped
with the kernel-sources in tools-dir to track down a BROKEN Linux-Next
release (see [2]).

Thanks in advance.

Regards,
- Sedat -

[1] http://lists.debian.org/debian-kernel/2012/02/msg01009.html
[2] http://www.spinics.net/lists/cpufreq/msg05291.html
