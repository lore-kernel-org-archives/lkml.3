Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758745AbaKUPfQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 10:35:16 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:51727 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758399AbaKUPfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 10:35:14 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pm >> Linux PM mailing list" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [GIT PULL] cpuidle: A few improvements for ARM cpuidle via DT
Date: Fri, 21 Nov 2014 16:56:22 +0100
Message-ID: <17509116.2bjC4d8bef@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <546C6DEB.8060204@linaro.org>
References: <546C6DEB.8060204@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 19, 2014 11:16:11 AM Daniel Lezcano wrote:
> 
> Hi Rafael,
> 
> this pull request, based on 3.18-rc5, contains a set of changes from 
> Lorenzo Pieralisi.
> 
>   * Added a 'status' definition flag in the DT to specify the 
> unsupported firmware idle states and ignore those states in the parsing 
> code when initializing the cpuidle driver
> 
>   * Added an idle state description in the DT. As the idle states are 
> not standardized on ARM, the description gives information about the 
> idle state
> 
>   * Removed duplicate error message in the arm64 cpuidle drivers
> 
> Thanks !
> 
>    -- Daniel
> 
> 
> The following changes since commit fc14f9c1272f62c3e8d01300f52467c0d9af50f9:
> 
>    Linux 3.18-rc5 (2014-11-16 16:36:20 -0800)
> 
> are available in the git repository at:
> 
>    http://git.linaro.org/git-ro/people/daniel.lezcano/linux.git cpuidle/3.19
> 
> for you to fetch changes up to 18f95a3640dbf421ab9532e517070a0c1cd4d582:
> 
>    drivers: cpuidle: Remove cpuidle-arm64 duplicate error messages 
> (2014-11-19 10:16:28 +0100)

Pulled, but I had a conflict with one patch from you I'd already queued up for
3.19-rc1.

Can you please have a look at my bleeding-edge branch and check if I resolved
the conflict correctly?

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
