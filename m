Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843AbaIDVX7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 17:23:59 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:53157 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087AbaIDVXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 17:23:55 -0400
Date: Thu, 4 Sep 2014 15:23:50 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Quentin Lambert <lambert.quentin@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        Scott Murray <scott@spiteful.org>, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Fixing checkpatch errors and warnings for PCI hotplug
Message-ID: <20140904212350.GE17125@google.com>
References: <20140804185923.GA4185@greed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140804185923.GA4185@greed>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 08:59:23PM +0200, Quentin Lambert wrote:
> Patch 1 and 2 fix checkpatch coding style warnings.
> 
> Patch 3 fixes chechpatch errors due to assignement
> in if conditions.
> 
> 
> Quentin Lambert (3):
>   PCI hotplug: fix a missing space coding style issue
>   PCI hotplug: fix a simple if coding style issue
>   PCI hotplug: remove assignement from if conditions

I don't mind doing changes like these, but when we do, I want to do the
whole drivers/pci directory at once to minimize the churn.  I don't know
how you did these, but it looks like there are more instances than are
fixed by these patches, e.g.,

    drivers/pci/hotplug/cpcihp_generic.c:	if(!bridge) {
    drivers/pci/pci.c:      if ((i = pci_save_pcie_state(dev)) != 0)
