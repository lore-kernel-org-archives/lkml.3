Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab3I0S6u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 14:58:50 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:34393 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482Ab3I0S6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 14:58:47 -0400
MIME-Version: 1.0
In-Reply-To: <20130926150228.GL11119@titan.lakedaemon.net>
References: <CAErSpo7UX6dt0CPZp3kEQrXXbMeArpu1iFfp=-FX46LVgq0iMw@mail.gmail.com>
 <20130926150228.GL11119@titan.lakedaemon.net>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 27 Sep 2013 12:58:26 -0600
Message-ID: <CAErSpo5tN==4nSv2u3SUBe_L4VsWn4P7TN+LtrC172Qj1vhtog@mail.gmail.com>
Subject: Re: PCI host merge strategy and maintainers
To: Jason Cooper <jason@lakedaemon.net>
Cc: Frank Li <lznuaa@gmail.com>, Shawn Guo <shawn.guo@linaro.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Kevin Hilman <khilman@linaro.org>, Stephen Warren <swarren@nvidia.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 9:02 AM, Jason Cooper <jason@lakedaemon.net> wrote:
> On Wed, Sep 25, 2013 at 05:28:28PM -0600, Bjorn Helgaas wrote:
>> There are patches for exynos, imx6, mvebu, and tegra on the PCI list,
>> and I want to sort out how people expect them to be merged.
>>
>> My current assumption is the following:
> ...
>>   drivers/pci/host/pci-mvebu.c  ?? unclear; Jason Cooper has merged
>> some, I've merged some

...

> Well, there's nothing new here, so if you're ok with me taking them,
> I'll continue on that path for these two series.

OK, I'll assume Jason will take care of pci-mvebu.c, and I will merge
changes to everything else via the PCI tree.  I will still wait for
acks from the following before merging things:

  designware: Jingoo Han <jg1.han@samsung.com>
  exynos: Jingoo Han <jg1.han@samsung.com>
  imx6: Shawn Guo <shawn.guo@linaro.org>
  tegra: Thierry Reding <thierry.reding@gmail.com>

Bjorn
