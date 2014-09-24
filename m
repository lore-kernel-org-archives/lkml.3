Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644AbaIXQOq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:14:46 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:55741 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbaIXQOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:14:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Robert Richter <rric@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Liviu Dudau <liviu.dudau@arm.com>,
        Rob Herring <robh+dt@kernel.org>, Sunil Goutham <sgoutham@cavium.com>,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Robert Richter <rrichter@cavium.com>
Subject: Re: [PATCH 5/6] arm64, defconfig: Enable PCI
Date: Wed, 24 Sep 2014 18:14:11 +0200
Message-ID: <7901403.qjKNmO519a@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1411573068-12952-6-git-send-email-rric@kernel.org>
References: <1411573068-12952-1-git-send-email-rric@kernel.org> <1411573068-12952-6-git-send-email-rric@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:KEIvrTeii8d2h6j5/wxApa+D6IHWtPNr2AvCBDgV+Ht
 Hm4awEHtd/AZjLLqnCnjDJJQ6uYWb6kg0QmZ7YKtQxLLw0A0Nm
 qBctg4rHw6qB6h+AYukP1N35/8K1adtngeaCwtnaGZ0oCvKoG8
 ukZTzsLbpXsONws7k7N8T8qt+KD4KpU0eqrpcExOVhPWUk9fzX
 KFZ+aOnxT9vh1UzzwOjnw1Z3724dsH1r10IHWSefhA+baLuRre
 blmKTvDxjrJ/uCAPXdwBqmjFgvdigzZY16LQCBpHFD8EKG8F9w
 SjDiD1vyCiwGNnumU5dpTuEYAGx93YtpO8N7h5rCwsbxnESOA+
 58h2634LaJXNhox35f+U=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 September 2014 17:37:47 Robert Richter wrote:
>  config PCI
>         bool "PCI support"
> +       default y
>         help
>           This feature enables support for PCIe bus system. If you say Y
>           here, the kernel will include drivers and infrastructure code
>           to support PCIe bus devices.
>  
> +config PCI_MSI
> +       def_bool PCI
> +
>  config PCI_DOMAINS
>         def_bool PCI

There is already a PCI_MSI symbol in drivers/pci/Kconfig. Just select that
from the PCI symbol above rather than defining a second one.

	Arnd
