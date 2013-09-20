Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab3ITM1u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 08:27:50 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:37780 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646Ab3ITM1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 08:27:46 -0400
Date: Fri, 20 Sep 2013 07:27:36 -0500
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jan Beulich <JBeulich@suse.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 2/6] PCI/MSI: Factor out pci_get_msi_cap() interface
Message-ID: <20130920122736.GD7630@mtj.dyndns.org>
References: <CAErSpo4TU2geqzY3AYsL08KimBqtfwa4iUoFHgcFt0zMTBJkHw@mail.gmail.com>
 <20130906160621.GF22763@mtj.dyndns.org>
 <20130906233205.GF12956@google.com>
 <20130909152044.GA24962@dhcp-26-207.brq.redhat.com>
 <20130916102210.GA14102@dhcp-26-207.brq.redhat.com>
 <20130917143022.GA7707@concordia>
 <20130918094759.GA2353@dhcp-26-207.brq.redhat.com>
 <20130918142231.GA21650@mtj.dyndns.org>
 <20130918165045.GB2353@dhcp-26-207.brq.redhat.com>
 <20130920082458.GA10507@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130920082458.GA10507@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 20, 2013 at 10:24:59AM +0200, Alexander Gordeev wrote:
> * Make pci_enable_msix() return 0/-errno

My choice would be this one.

Thanks.

-- 
tejun
