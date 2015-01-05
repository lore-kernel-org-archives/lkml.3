Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345AbbAESsY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 13:48:24 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:39912 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299AbbAESsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 13:48:23 -0500
Date: Mon, 5 Jan 2015 19:48:21 +0100
From: Andreas Mohr <andi@lisas.de>
To: Rob Herring <robh@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, Will Deacon <will.deacon@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Rob Herring <robh@kernel.org>
Subject: Re: [PATCH] pci: introduce common pci config space accessors
Message-ID: <20150105184821.GA703@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420424374-32412-1-git-send-email-robh@kernel.org>
X-Priority: none
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> +	if (size == 1)
> +		*val = readb(addr);
> +	else if (size == 2)
> +		*val = readw(addr);
> +	else
> +		*val = readl(addr);
(pci_generic_config_read() and pci_generic_config_write())

switch()
default: WARN_ON(1);
?

Thanks,

Andreas Mohr
