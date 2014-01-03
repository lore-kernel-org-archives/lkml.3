Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265AbaACX4g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 18:56:36 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:35174 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834AbaACX4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 18:56:12 -0500
Date: Fri, 03 Jan 2014 18:56:07 -0500 (EST)
Message-Id: <20140103.185607.1380379872647540168.davem@davemloft.net>
To: bhelgaas@google.com
Cc: jesse.brandeburg@gmail.com, linux-pci@vger.kernel.org,
        jeffrey.t.kirsher@intel.com, netdev@vger.kernel.org, gospo@redhat.com,
        sassmann@redhat.com, linux-kernel@vger.kernel.org,
        bjorn.helgaas@hp.com
Subject: Re: [net-next] pci_regs.h: Add PCI bus link speed and width defines
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAErSpo7K3OBuTEZrXmhQ3iXtLf3M5JNnEqmAvaceroJ46VAOKg@mail.gmail.com>
References: <20140102.192133.1585340046080167370.davem@davemloft.net>
	<CAEuXFEw=A0mppxtgzpmnh3feLiKYb+LJQvFRMrW3C4h+jHpO2Q@mail.gmail.com>
	<CAErSpo7K3OBuTEZrXmhQ3iXtLf3M5JNnEqmAvaceroJ46VAOKg@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 03 Jan 2014 15:56:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 3 Jan 2014 15:15:57 -0700

> However, I do raise my eyebrows a bit at drivers that poke around in
> the PCIe capability.  I would prefer to have PCI core interfaces that
> handle that instead.  But I haven't seen Jeff's changes yet.

The changes just read the link status to interpret the speed at which
the PCI-E link is running at.
