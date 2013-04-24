Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126Ab3DXJBB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 05:01:01 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:56154 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757768Ab3DXJA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 05:00:57 -0400
MIME-Version: 1.0
In-Reply-To: <0C6A3B2997299B4EAD81D386F36CD8C20FD926AD@SHSMSX102.ccr.corp.intel.com>
References: <0C6A3B2997299B4EAD81D386F36CD8C20FD91958@SHSMSX102.ccr.corp.intel.com>
	<CADJHv_sdbn8hPYOTsWaJQiO276Y5Zto85pjqMR=xD+NOJJKY+A@mail.gmail.com>
	<0C6A3B2997299B4EAD81D386F36CD8C20FD926AD@SHSMSX102.ccr.corp.intel.com>
Date: Wed, 24 Apr 2013 17:00:56 +0800
Message-ID: <CADJHv_vL16joo1QQ0nx2DzZraQ4W0pEvLbn8vMNzp6Mz-L6yLA@mail.gmail.com>
Subject: Re: NumaTOP 1.0 launched
From: zhou jencce <jencce.kernel@gmail.com>
To: "Jin, Yao" <yao.jin@intel.com>
Cc: "lwn@lwn.net" <lwn@lwn.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/24 Jin, Yao <yao.jin@intel.com>:
> Hi Zhou,
>
>
>
> I just worry a little bit if you can apply the raw patch on the tip or other
> version of kernel code. You know, the perf code is changed frequently.
>
>
>
> Thanks
>
> Jin Yao
>
>
>

That's OK,  I'd like to try.


Thanks
XIong


> From: zhou jencce [mailto:jencce.kernel@gmail.com]
> Sent: Wednesday, April 24, 2013 4:26 PM
> To: Jin, Yao
> Cc: lwn@lwn.net; linux-kernel@vger.kernel.org;
> linux-perf-users@vger.kernel.org
>
>
> Subject: Re: NumaTOP 1.0 launched
>
>
>
>
>
>
>
> 2013/4/18 Jin, Yao <yao.jin@intel.com>
>
> Hi,
>
> https://01.org/numatop/ is slightly faster to access.
> Or please access https://github.com/01org/numatop to get the source
> directly.
>
> Thanks
> Jin Yao
>
>
> -----Original Message-----
> From: Jin, Yao
> Sent: Wednesday, April 17, 2013 10:30 AM
> To: 'lwn@lwn.net'; 'linux-kernel@vger.kernel.org';
> 'linux-perf-users@vger.kernel.org'
> Subject: NumaTOP 1.0 launched
>
> We are pleased to announce today that the NumaTOP project has been added to
> 01.org.
>
> Performance analysis engineers know that NUMA can seriously impact
> performance and that NUMA performance analysis can be challenging. We've
> realized that currently there isn't an easy-to-use tool that lets us easily
> observe whether NUMA-related issues exist and, if so, where the NUMA
> bottleneck(s) reside. It can be quite challenging, especially in complex
> server environments.
>
> We decided to create a tool that automatically performs the typical steps in
> NUMA analysis and provides a good starting point to dive in and fix
> NUMA-related bottlenecks. That's NumaTOP!
>
> NumaTOP is an observation tool for runtime memory locality characterization
> and analysis of processes and threads running on a NUMA system. It helps the
> user characterize the NUMA behavior of processes and threads and identify
> where the NUMA-related performance bottlenecks reside. It uses Intel
> performance counter sampling technologies and associates the performance
> data with system runtime information to provide real-time analysis for
> production systems.
>
> NumaTOP is a GUI tool. It can run on Linux kernel 3.8 with a perf load
> latency patch today. That patch is planned to be integrated into kernel 3.9
> or a later release.
>
> To learn more about NumaTOP, visit:
> http://01.org/numatop/
>
> Best Regards
> Jin Yao
>
>
>
> Hi,  I am wondering whether  the separated kernel patch is available. It
> would be very helpful to my pool networking and my strong curiosity to try
> NumaTop.:)
>
> Thanks.
>
>
>
>
>
> Xiong
>
>
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
