Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760150Ab3JPW3e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 18:29:34 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:59523 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753468Ab3JPW3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 18:29:32 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: linux-kernel@vger.kernel.org
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-pm@vger.kernel.org, gregkh@linuxfoundation.org,
        len.brown@intel.com, arjan@linux.intel.com,
        jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH v3 0/6] Power Capping Framework and RAPL Driver
Date: Thu, 17 Oct 2013 00:41:23 +0200
Message-ID: <2461734.gXdEFC695q@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1381535700-2408-1-git-send-email-srinivas.pandruvada@linux.intel.com>
References: <1381535700-2408-1-git-send-email-srinivas.pandruvada@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 11, 2013 04:54:54 PM Srinivas Pandruvada wrote:
> Overview
> With the evolution of technologies, which enables power monitoring and limiting,
> more and more devices are able to constrain their power consumption under certain
> limits. There are several use cases for such technologies:
> - Power monitoring: Each device can report its power consumption.
> - Power Limiting: Setting power limits on the devices allows users to guard against
> platform reaching max system power level.
> - Maximize performance: While staying below a power limit, it allows devices to
> automatically adjust performance to meet demands
> - Dynamic control and re-budgeting: If each device can be constrained to some power,
> extra power can redistributed to other devices, which needs additional performance.
> 
> One such example of technologies is RAPL (Running Average Power Limit) mechanism
> available in the latest Intel processors. Intel is slowly adding many devices under
> RAPL control. Also there are other technologies available, for power capping various
> devices. Soon it is very likely that other vendors are also adding or considering
> such implementation.
> 
> Power Capping framework is an effort to have a uniform interface available to Linux
> drivers, which will enable
> - A uniform sysfs interface for all devices which can offer power capping
> - A common API for drivers, which will avoid code duplication and easy
> implementation of client drivers.
> 
> Also submitting Intel RAPL driver using power capping framework.

Are there any comments or objections against this?

If not, I'd like to queue it up for 3.13.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
