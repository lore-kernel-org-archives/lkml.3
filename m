Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629AbaADBsb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 20:48:31 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:35715 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101AbaADBsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 20:48:30 -0500
Date: Fri, 03 Jan 2014 20:48:26 -0500 (EST)
Message-Id: <20140103.204826.924684292174040714.davem@davemloft.net>
To: jeffrey.t.kirsher@intel.com
Cc: bhelgaas@google.com, jesse.brandeburg@gmail.com, linux-pci@vger.kernel.org,
        netdev@vger.kernel.org, gospo@redhat.com, sassmann@redhat.com,
        linux-kernel@vger.kernel.org, bjorn.helgaas@hp.com
Subject: Re: [net-next] pci_regs.h: Add PCI bus link speed and width defines
From: David Miller <davem@davemloft.net>
In-Reply-To: <1388798859.2275.5.camel@jtkirshe-mobl>
References: <CAErSpo7TJXTCxpFKWXLTaHmqXXnYQdnpNeWt+cehSaES2Jh30w@mail.gmail.com>
	<20140103.193008.684316024702680161.davem@davemloft.net>
	<1388798859.2275.5.camel@jtkirshe-mobl>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 03 Jan 2014 17:48:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Fri, 03 Jan 2014 17:27:39 -0800

> What do you want to do with the current series of patches
> (mainly the ixgbe LER patches) on my tree?  I know that there is a
> thread going on between Joe Perches and Mark, but it sounded like Mark
> is working on a follow-on patch to address Joe's concerns.

I want the LER config option removed.
