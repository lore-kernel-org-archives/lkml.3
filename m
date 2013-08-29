Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab3H2K2G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 06:28:06 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37293 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134Ab3H2K2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 06:28:03 -0400
Message-ID: <521F2112.5070501@ti.com>
Date: Thu, 29 Aug 2013 15:53:14 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>, Eric Miao <eric.y.miao@gmail.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        John Crispin <blogic@openwrt.org>, <linux-cris-kernel@axis.com>,
        <linux-sh@vger.kernel.org>, Mikael Starvik <starvik@axis.com>,
        Paul Mundt <lethal@linux-sh.org>, <sparclinux@vger.kernel.org>,
        Miao Steven <realmz6@gmail.com>, Dave Jones <davej@redhat.com>
Subject: Re: [Query] CPUFreq: Does these machines have separate clock domains
 for CPUs?
References: <CAKohponWn-RN7-6sdhghd6RGCOd357G+TKLsxHfqnSCuMD7xxw@mail.gmail.com>
In-Reply-To: <CAKohponWn-RN7-6sdhghd6RGCOd357G+TKLsxHfqnSCuMD7xxw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 August 2013 03:45 PM, Viresh Kumar wrote:
> Hi,
> 
> I have been doing some CPUFreq cleanup work and
> wanted to know if the below mentioned machines have separate
> clock domains for their CPUs or all share the same domain?

On DaVinci (DA850), there is an async domain available to keep some
peripheral clocks insulated from cpu frequency changes. But there are a
bunch of other clocks which do get affected by CPU frequency change
(they need to run at a fixed ratio to CPU frequency).

Thanks,
Sekhar
