Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996Ab3LLU3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 15:29:25 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:64367 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566Ab3LLU3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 15:29:20 -0500
MIME-Version: 1.0
In-Reply-To: <20131212070045.GO18380@S2101-09.ap.freescale.net>
References: <20131211183237.GI4699@google.com> <20131212070045.GO18380@S2101-09.ap.freescale.net>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 12 Dec 2013 13:29:00 -0700
Message-ID: <CAErSpo5O1nSkKmWfHGGZiuVdvRxFjNNDS-8BWKFhnCgwVSdr8A@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: Add DesignWare, i.MX6, Armada, R-Car PCI
 host maintainers
To: Shawn Guo <shawn.guo@linaro.org>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        linux-sh@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>, Jason Cooper <jason@lakedaemon.net>,
        Thierry Reding <thierry.reding@gmail.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Valentine Barshak <valentine.barshak@cogentembedded.com>,
        Wei Yongjun <weiyj.lk@gmail.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Richard Zhu <r65037@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 12:00 AM, Shawn Guo <shawn.guo@linaro.org> wrote:
> Hi Bjorn,
>
> On Wed, Dec 11, 2013 at 11:32:37AM -0700, Bjorn Helgaas wrote:
>> +PCI DRIVER FOR IMX6
>> +M:   Shawn Guo <shawn.guo@linaro.org>
>
> Thanks for the nomination.  But I think a better person for this
> position would be Richard Zhu <r65037@freescale.com> (copied).  He knows
> the driver and controller much better than myself, and most importantly
> he is the driver owner for Freescale kernel and he has the contact to
> Freescale PCIe hardware people.

Richard, are you OK with being listed here?  Shawn, do you want to be
listed here in addition, if only to make sure you're copied on changes
to pci-imx6.c?
