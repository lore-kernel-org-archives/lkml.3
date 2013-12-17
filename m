Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab3LQU3C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 15:29:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909Ab3LQU27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 15:28:59 -0500
Message-ID: <1387312137.30327.11.camel@bling.home>
Subject: Re: [PATCH 3/3] pci: Add Virtual Channel to save/restore support
From: Alex Williamson <alex.williamson@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, ddutile@redhat.com,
        linux-kernel@vger.kernel.org
Date: Tue, 17 Dec 2013 13:28:57 -0700
In-Reply-To: <20131217180322.GA12482@google.com>
References: <20131210183339.26294.14581.stgit@bling.home>
	 <20131210184845.26294.81385.stgit@bling.home>
	 <20131217180322.GA12482@google.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-17 at 11:03 -0700, Bjorn Helgaas wrote:
> On Tue, Dec 10, 2013 at 11:48:45AM -0700, Alex Williamson wrote:
> >...
> > +	pci_read_config_dword(dev->bus->self, pos2 + PCI_VC_PORT_REG1, &reg1);
> > +	evcc = reg1 & PCI_VC_REG1_EVCC;
> 
> I think PCI_VC_PORT_REG1 and PCI_VC_PORT_REG2 are mis-named and should be
> changed to CAP1 and CAP2 or similar.  Almost everything here is a
> "register."

That's true, but it matches the name in the spec: "Port VC Capability
Register 1/2".  Thanks,

Alex

