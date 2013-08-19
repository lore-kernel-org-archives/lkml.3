Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358Ab3HSLpm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 07:45:42 -0400
Received: from mail-vb0-f53.google.com ([209.85.212.53]:33233 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab3HSLpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 07:45:40 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohponkLac2GzZ5-PRoTzdx8EhuCWT-eafRtYhkJ6cN_WrXSA@mail.gmail.com>
References: <cover.1375809311.git.viresh.kumar@linaro.org>
	<e54ce908bb964d643a2bbb945ed4a8dcb3ea00bf.1375809311.git.viresh.kumar@linaro.org>
	<1582060.zfvsylJcxu@vostro.rjw.lan>
	<CAKohponkLac2GzZ5-PRoTzdx8EhuCWT-eafRtYhkJ6cN_WrXSA@mail.gmail.com>
Date: Mon, 19 Aug 2013 17:15:39 +0530
Message-ID: <CAP245DXKpDBetXHY_C0hSu0UHbeiFkhQ3r7V_3HOjQ+RkuabsQ@mail.gmail.com>
Subject: Re: [PATCH V2 07/11] cpufreq: Use cpufreq_policy_list for iterating
 over policies
From: Amit Kucheria <amit.kucheria@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Patch Tracking <patches@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Andy Whitcroft <apw@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 4:57 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:

> Testing anything on my thinkpad (with ubuntu) is a pain.. it takes
> more than an hour to compile/test a single image... I currently follow
> below steps for doing that, don't know if something much
> simpler/faster is available :)
>
> https://wiki.ubuntu.com/KernelTeam/GitKernelBuild
>
> Whole day I was able to boot test only 4-5 kernel builds.
> Its too slow :(

Why do you create .deb packages to test development kernels? It _is_ slow.

Instead I'd just add a new grub menu entry to /boot/grub/grub.cfg and
point it to /boot/MyzImage. After a 'make install; make
modules_install' just link /boot/MyzImage to the installed kernel in
/boot. And then generate a new initramfs using 'update-initramfs -c -k
<ver>'
