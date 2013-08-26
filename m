Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869Ab3HZOG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 10:06:59 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:40170 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756735Ab3HZOG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 10:06:57 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpoksNiGT+r3JTY6KFwnDFA5OYE-vQe8W_9GT-fN21UMrfQ@mail.gmail.com>
References: <CAKohpoksNiGT+r3JTY6KFwnDFA5OYE-vQe8W_9GT-fN21UMrfQ@mail.gmail.com>
Date: Mon, 26 Aug 2013 19:36:56 +0530
Message-ID: <CAKohpo=2msHhAWqqe==yLCszE5U6ccSti31E82eovkb4emJd5A@mail.gmail.com>
Subject: Re: [GIT PULL]: CPUFreq: ARM Fixes for 3.12
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Joseph Lo <josephl@nvidia.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 August 2013 11:48, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> Hi Rafael,
>
> Hopefully this is the last patch for 3.12 for ARM CPUFreq subsystem.

Another last minute patch from Sascha..

-----------x------------------x------------------

The following changes since commit b36f4be3de1b123d8601de062e7dbfc904f305fb:

  Linux 3.11-rc6 (2013-08-18 14:36:53 -0700)

are available in the git repository at:

  git://git.linaro.org/people/vireshk/linux.git cpufreq-fixes

for you to fetch changes up to fae19b84724ff93c1ac59ce1eecc1411f8269d9e:

  cpufreq: imx6q: Fix clock enable balance (2013-08-26 19:34:07 +0530)

----------------------------------------------------------------
Joseph Lo (1):
      cpufreq: tegra: fix the wrong clock name

Sascha Hauer (1):
      cpufreq: imx6q: Fix clock enable balance

 drivers/cpufreq/imx6q-cpufreq.c | 17 -----------------
 drivers/cpufreq/tegra-cpufreq.c |  4 ++--
 2 files changed, 2 insertions(+), 19 deletions(-)
