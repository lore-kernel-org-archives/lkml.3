Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab3GIOXO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 10:23:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:44698 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753638Ab3GIOXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 10:23:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1028,1363158000"; 
   d="scan'208";a="342743791"
Date: Tue, 9 Jul 2013 22:22:40 +0800
From: Haicheng Li <haicheng.li@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haicheng Li <haicheng.lee@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 1/3] PCI: Add hide_device support to pci subsystem.
Message-ID: <20130709142239.GB5954@hli22-desktop>
References: <1372864578-6925-1-git-send-email-haicheng.li@linux.intel.com>
 <CAErSpo5dR_2tUDFoFO49N3Ut569+6Cfosx8Q=91U_w-8mvFVkg@mail.gmail.com>
 <20130704045316.GC3244@hli22-desktop>
 <CAErSpo73pzpK1-401m9+EOiV_t13KY_DQa9WDU+5Gq+LidGpYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo73pzpK1-401m9+EOiV_t13KY_DQa9WDU+5Gq+LidGpYg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 05, 2013 at 11:28:40AM -0600, Bjorn Helgaas wrote:
> >> > To hide pci devices, just pass such parameters to kernel at boot stage:
> >> >         pci=hide=[<domain>:]<bus>:<slot>.<func>[; ...]
> 
> This doesn't seem generally useful to me.  It might be useful as a
> development aid, and you can easily maintain it as an out-of-tree
> patch for that.

That's fine, I can maintain it as out-of-tree patch:).
 
Thank you for the review.

> Bjorn
