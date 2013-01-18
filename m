Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab3ARLpp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 06:45:45 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49406 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab3ARLpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 06:45:44 -0500
Date: Fri, 18 Jan 2013 11:43:40 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andrew Murray <Andrew.Murray@arm.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Arnd Bergmann <arnd@arndb.de>, Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH RFC 2/2] Improve bios32 support for DT PCI host bridge
	controllers
Message-ID: <20130118114340.GD23505@n2100.arm.linux.org.uk>
References: <20130118114019.GA9034@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130118114019.GA9034@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 11:40:19AM +0000, Andrew Murray wrote:
>  static void __init pcibios_init_hw(struct hw_pci *hw, struct list_head *head)
>  {
>  	struct pci_sys_data *sys = NULL;
> +	static int busnr;
>  	int ret;
> -	int nr, busnr;
> -
> -	for (nr = busnr = 0; nr < hw->nr_controllers; nr++) {
> +	int nr;
> +	for (nr = 0; nr < hw->nr_controllers; nr++) {

Please try to retain the originally formatting.  There should be a blank
line between "int nr;" and "for...".
