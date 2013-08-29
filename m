Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab3H2Wlk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 18:41:40 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:56012 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679Ab3H2Wlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 18:41:37 -0400
Date: Fri, 30 Aug 2013 01:41:28 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>, Eric Miao <eric.y.miao@gmail.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        John Crispin <blogic@openwrt.org>, linux-cris-kernel@axis.com,
        linux-sh@vger.kernel.org, Mikael Starvik <starvik@axis.com>,
        Paul Mundt <lethal@linux-sh.org>, Sekhar Nori <nsekhar@ti.com>,
        sparclinux@vger.kernel.org, Miao Steven <realmz6@gmail.com>,
        Dave Jones <davej@redhat.com>
Subject: Re: [Query] CPUFreq: Does these machines have separate clock domains
 for CPUs?
Message-ID: <20130829224127.GA15841@blackmetal.musicnaut.iki.fi>
References: <CAKohponWn-RN7-6sdhghd6RGCOd357G+TKLsxHfqnSCuMD7xxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohponWn-RN7-6sdhghd6RGCOd357G+TKLsxHfqnSCuMD7xxw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Aug 29, 2013 at 03:45:58PM +0530, Viresh Kumar wrote:
> I have been doing some CPUFreq cleanup work and
> wanted to know if the below mentioned machines have separate
> clock domains for their CPUs or all share the same domain?
[...]
> drivers/cpufreq/loongson2_cpufreq.c

Loongson2 is UP only.

A.
