Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbaBKAQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 19:16:30 -0500
Received: from mail-ig0-f178.google.com ([209.85.213.178]:40939 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbaBKAQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 19:16:28 -0500
Date: Mon, 10 Feb 2014 17:16:24 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Andreas Noever <andreas.noever@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 0/8] PCI: cleanup pci_scan_bridge
Message-ID: <20140211001624.GA12851@google.com>
References: <1390510768-5652-1-git-send-email-andreas.noever@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390510768-5652-1-git-send-email-andreas.noever@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 09:59:20PM +0100, Andreas Noever wrote:
> I have been reading the code around pci_scan_bridge and noticed a few oddities.
> These patches try to cleanup some of the these things.
> 
> Most of the patches make also sense in isolation, but some make more sense with
> the previous ones applied as well. None of the patches fix any observed bugs.
> Patch 5 fixes a (probably harmless) dmesg.
> 
> The changes related to CardBus probing are completely untested.
> 
> Andreas
> 
> Andreas Noever (8):
>   PCI: Increment max correctly in pci_scan_bridge.
>   PCI: Clarify the "scan anyway" comment in pci_scan_bridge.
>   PCI: Assign CardBus bus number only during the second pass.
>   PCI: Use request_resource_conflict instead of insert_ for bus numbers.
>   PCI: Make sure bus number resources stay within their parents bounds.
>   PCI: Remove pci_fixup_parent_subordinate_busnr.
>   PCI: Check for child busses which use more bus numbers than allocated.
>   PCI: Don't scan random busses in pci_scan_bridge.
> 
>  drivers/pci/probe.c | 78 +++++++++++++++++++++--------------------------------
>  1 file changed, 31 insertions(+), 47 deletions(-)

I applied all these to pci/scan-bridge for v3.15, thanks!

Bjorn
