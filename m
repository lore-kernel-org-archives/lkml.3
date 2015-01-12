Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbbALSUn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:20:43 -0500
Received: from mail-oi0-f48.google.com ([209.85.218.48]:38685 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910AbbALSUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:20:38 -0500
Date: Mon, 12 Jan 2015 11:20:29 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 4/5] PCI: qcom: Add Qualcomm PCIe controller driver
Message-ID: <20150112182029.GA2776@google.com>
References: <1418404441-5518-1-git-send-email-svarbanov@mm-sol.com>
 <1418404441-5518-5-git-send-email-svarbanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418404441-5518-5-git-send-email-svarbanov@mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 07:14:00PM +0200, Stanimir Varbanov wrote:
> The PCIe driver reuse the Designware common code for host
> and MSI initialization, and also program the Qualcomm
> application specific registers.
> 
> Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
> ---
>  drivers/pci/host/Kconfig     |    9 +
>  drivers/pci/host/Makefile    |    1 +
>  drivers/pci/host/pcie-qcom.c |  415 ++++++++++++++++++++++++++++++++++++++++++

Hi Stanimir,

Can you also add a MAINTAINERS update so I'll know who should ack changes
to this driver?

Bjorn
