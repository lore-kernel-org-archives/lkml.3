Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273Ab3LCB1O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 20:27:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43877 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab3LCB1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 20:27:12 -0500
Date: Mon, 2 Dec 2013 17:27:11 -0800
From: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Joe Perches'" <joe@perches.com>, linux-kernel@vger.kernel.org,
        "'Bjorn Helgaas'" <bhelgaas@google.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH 38/39] PCI: remove DEFINE_PCI_DEVICE_TABLE macro
Message-ID: <20131203012711.GA32730@kroah.com>
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
 <003b01ceefb6$bca43ed0$35ecbc70$%han@samsung.com>
 <1386028330.15309.13.camel@joe-AO722>
 <003e01ceefc5$1a6f9880$4f4ec980$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <003e01ceefc5$1a6f9880$4f4ec980$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 10:15:06AM +0900, Jingoo Han wrote:
> On Tuesday, December 03, 2013 8:52 AM, Joe Perches wrote:
> > On Tue, 2013-12-03 at 08:32 +0900, Jingoo Han wrote:
> > > Don't use DEFINE_PCI_DEVICE_TABLE macro, because this macro
> > > is not preferred. Also, the definition of DEFINE_PCI_DEVICE_TABLE
> > > macro is removed.
> > 
> > These sorts of treewide conversions are almost never
> > applied wholesale.
> > 
> > This patch is not appropriate until there are no more
> > uses of DEFINE_PCI_DEVICE_TABLE in Linus' tree.
> > 
> > Just marking the function as deprecated in the
> > documentation and the pci.h file is probably good
> > enough for now.
> > 
> > see:  http://lkml.org/lkml/2013/12/2/400
> 
> Actually, I want to remove all DEFINE_PCI_DEVICE_TABLEs from the
> next 3.14-rc1 kernel, by merging all patches through Greg's tree.
> 
> Greg,
> How about you?

No, take them through their individual driver trees please.

thanks,

greg k-h
