Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab3H2KaK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 06:30:10 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:35991 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706Ab3H2KaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 06:30:07 -0400
MIME-Version: 1.0
In-Reply-To: <521F2112.5070501@ti.com>
References: <CAKohponWn-RN7-6sdhghd6RGCOd357G+TKLsxHfqnSCuMD7xxw@mail.gmail.com>
	<521F2112.5070501@ti.com>
Date: Thu, 29 Aug 2013 16:00:06 +0530
Message-ID: <CAKohponHDZB37UsacYpmaJPb2-P3b_CJ51e7o=X+D3M68GcdEQ@mail.gmail.com>
Subject: Re: [Query] CPUFreq: Does these machines have separate clock domains
 for CPUs?
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Sekhar Nori <nsekhar@ti.com>
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
        Paul Mundt <lethal@linux-sh.org>, sparclinux@vger.kernel.org,
        Miao Steven <realmz6@gmail.com>, Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 August 2013 15:53, Sekhar Nori <nsekhar@ti.com> wrote:
> On DaVinci (DA850), there is an async domain available to keep some
> peripheral clocks insulated from cpu frequency changes. But there are a
> bunch of other clocks which do get affected by CPU frequency change
> (they need to run at a fixed ratio to CPU frequency).

My question wasn't about how peripherals are getting clocks.. but how
CPUs are getting them..

Does all CPUs share clock line in Davinci? i.e. if we change freq of one
cpu then freq of other one also gets changed?

Or they are capable of running at different frequencies?

--
viresh
