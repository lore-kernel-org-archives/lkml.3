Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbaCFPoN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 10:44:13 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:58586 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbaCFPoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 10:44:10 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Subject: Re: [PATCH v5 1/7] pci: Introduce pci_register_io_range() helper function.
Date: Tue, 4 Mar 2014 23:30:09 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "linux-pci" <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linaro-kernel" <linaro-kernel@lists.linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>
References: <1393948204-11555-1-git-send-email-Liviu.Dudau@arm.com> <1393948204-11555-2-git-send-email-Liviu.Dudau@arm.com>
In-Reply-To: <1393948204-11555-2-git-send-email-Liviu.Dudau@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201403042330.09607.arnd@arndb.de>
X-Provags-ID: V02:K0:YisFxHbwKKx9YX1Q4kLBFG870l5TVU43E5e6mlMQXYG
 +r8Fd+QuniLfSNVeR6mhhp9guQAk79bENVS642ovXFL7UsvdFV
 MPbXnrjeHqmm2AbrGHGRuwlKjQ8A6D9D6wmBDJYX2Tu7FikFnR
 Rs9xyChNL4cfNoNotGmZ41ogLzNrHAl2E/4MqphnNyrN7yGWKL
 Pffhcms3pJvT/21HjcwtdtZ61a/80Rhy5vryxa0rolEIeGh9Rv
 86FD9nRYzw9N+bwDGovylQ6hHWW4SLzuq3uIIzfFpQNnsQegVK
 WYURQje+5tYK8rnuSZuMbF2uB/EyQ7Owd0YPMHyXE4JD6ABuzZ
 fjM7sdbLvURXda/A9HHo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 March 2014, Liviu Dudau wrote:
> +int __weak pci_register_io_range(phys_addr_t addr, resource_size_t size)
> +{
> +       return 0;
> +}
> +

How about returning an error here? You don't actually register the range.

	Arnd
