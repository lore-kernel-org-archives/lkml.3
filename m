Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966299Ab3HHUEL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 16:04:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47671 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966063Ab3HHUEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 16:04:10 -0400
Message-ID: <5203F978.2050504@infradead.org>
Date: Thu, 08 Aug 2013 13:03:04 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci <linux-pci@vger.kernel.org>
Subject: Re: linux-next: Tree for Aug 8 (not CONFIG_PCI_MSI conflict)
References: <20130808170822.82bf33d3cf5100f5e2646815@canb.auug.org.au>
In-Reply-To: <20130808170822.82bf33d3cf5100f5e2646815@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/13 00:08, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20130807:
> 

on i386 and x86_64:
when CONFIG_PCI_MSI is not enabled:

There are many of these errors:
include/linux/msi.h:65:6: error: expected identifier or '(' before 'void'
include/linux/msi.h:65:6: error: expected ')' before numeric constant

because arch/x86/include/asm/pci.h defines:
#define default_teardown_msi_irqs	NULL


-- 
~Randy
