Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935088Ab3DHJSN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:18:13 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:53901 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935042Ab3DHJSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:18:08 -0400
MIME-Version: 1.0
In-Reply-To: <2ccd01ce3439$911b51b0$b351f510$%kim@samsung.com>
References: <cover.1365079581.git.viresh.kumar@linaro.org>
	<2a5901ce31c9$95160980$bf421c80$%kim@samsung.com>
	<CAKohpokk1Q+0gRpeW=ts0a8D+rGAUpHu62X+7ejdpfom_B6FYA@mail.gmail.com>
	<1769336.FkfMpuXqqb@vostro.rjw.lan>
	<2ccd01ce3439$911b51b0$b351f510$%kim@samsung.com>
Date: Mon, 8 Apr 2013 14:48:08 +0530
Message-ID: <CAKohpomcSF-o3piHeOONZuFubJ0xkBjHJRG7j7FN=NaXBiJPiw@mail.gmail.com>
Subject: Re: [PATCH 07/18] cpufreq: s3c24xx: move cpufreq driver to drivers/cpufreq
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, Ben Dooks <ben-linux@fluff.org>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 April 2013 14:45, Kukjin Kim <kgene.kim@samsung.com> wrote:
> Rafael J. Wysocki wrote:
>> Well, I'm dropping it.  Please merge via the Samsung tree.
>>
> OK, I will.
>
> I got patch file from Viresh, and there is a sign from Rafael, but it should be ack. So Rafael, let me use your ack on this patch when I apply. If any problems, please let me know.

Ahh.. I forgot to remove it. I picked the initial patch from Rafael's tree.
But yes, you need it anyway :)
