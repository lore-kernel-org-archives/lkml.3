Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401Ab3KXAoX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 19:44:23 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:41093 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609Ab3KXAoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 19:44:22 -0500
Date: Sun, 24 Nov 2013 00:41:32 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: "David E. Box" <david.e.box@linux.intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, rjw@sisk.pl,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 1/2] New Driver for IOSF-SB MBI access on Intel SOCs
Message-ID: <20131124004132.6ca1c0e1@alan.etchedpixels.co.uk>
In-Reply-To: <1385100357-5459-1-git-send-email-david.e.box@linux.intel.com>
References: <1385100357-5459-1-git-send-email-david.e.box@linux.intel.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Nov 2013 22:05:56 -0800
"David E. Box" <david.e.box@linux.intel.com> wrote:

> +static int iosf_mbi_probe(struct platform_device *pdev)
> +{
> +	struct resource *mem;
> +
> +	/* Get and map MBI address space */
> +	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	iosf_mbi_data.addr = devm_ioremap_resource(&pdev->dev, mem);

Purely "defensive driv(er)ing" but platform_get_resource can return NULL

Alan
