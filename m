Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab3LQSD1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:03:27 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:43100 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755224Ab3LQSDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:03:25 -0500
Date: Tue, 17 Dec 2013 11:03:22 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-pci@vger.kernel.org, ddutile@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] pci: Add Virtual Channel to save/restore support
Message-ID: <20131217180322.GA12482@google.com>
References: <20131210183339.26294.14581.stgit@bling.home>
 <20131210184845.26294.81385.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131210184845.26294.81385.stgit@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 11:48:45AM -0700, Alex Williamson wrote:
>...
> +	pci_read_config_dword(dev->bus->self, pos2 + PCI_VC_PORT_REG1, &reg1);
> +	evcc = reg1 & PCI_VC_REG1_EVCC;

I think PCI_VC_PORT_REG1 and PCI_VC_PORT_REG2 are mis-named and should be
changed to CAP1 and CAP2 or similar.  Almost everything here is a
"register."

Bjorn
