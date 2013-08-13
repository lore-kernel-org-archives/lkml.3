Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768Ab3HMRTe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 13:19:34 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:33520 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758115Ab3HMRTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 13:19:31 -0400
MIME-Version: 1.0
In-Reply-To: <20130813140130.GA25111@titan.lakedaemon.net>
References: <1376396724-32048-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <20130813140130.GA25111@titan.lakedaemon.net>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 13 Aug 2013 11:19:10 -0600
Message-ID: <CAErSpo7DnfQBzoSX+rh6A0QrPO3Z3cjD=8ajZiFwKH0MBTG4og@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] ARM: dove: DT PCIe support
To: Jason Cooper <jason@lakedaemon.net>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org, Thierry Reding <thierry.reding@gmail.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 8:01 AM, Jason Cooper <jason@lakedaemon.net> wrote:
> Bjorn,
>
> On Tue, Aug 13, 2013 at 02:25:19PM +0200, Sebastian Hesselbarth wrote:
>> This patch set adds support for the PCIe controllers found on Marvell
>> Dove SoCs. It depends on mvebu-pci patches sent by Thomas Petazzoni.
>
> Well, when it rains, it pours.  If this series looks good to you, I'll
> go ahead and add it on top of Thomas' patches.

Yep, that's fine with me.  I consider the stuff in drivers/pci/host/
as basically arch code that is collected as a convenience for code
sharing.  I can't test it, and I can only evaluate it as far as
looking for the most obvious things related to use of core PCI
interfaces.

Bjorn
