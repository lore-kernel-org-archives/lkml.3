Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbaHEOwL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 10:52:11 -0400
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:49256 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754335AbaHEOwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 10:52:09 -0400
Date: Tue, 5 Aug 2014 15:51:40 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Vishal Mansur <vmansur@linux.vnet.ibm.com>
Cc: gwshan@linux.vnet.ibm.com, benh@kernel.crashing.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc: non-GPL export for eeh_dev_check_failure
Message-ID: <20140805155140.2b200061@alan.etchedpixels.co.uk>
In-Reply-To: <53E0ED41.8030804@linux.vnet.ibm.com>
References: <53E0ED41.8030804@linux.vnet.ibm.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Aug 2014 20:12:09 +0530
Vishal Mansur <vmansur@linux.vnet.ibm.com> wrote:

> EEH kernel services are inconsistently exported by the 
> kernel. eeh_check_failure is exported for any use, but 
> eeh_dev_check_failure is exported only for GPL use. 
> While eeh_check_failure is implemented for a specific 
> purpose to be used by services such as readl, it is 
> not suited for a purpose where caller needs eeh status. 
> This functionality is provided by eeh_dev_check_failure.
> 
> This patch relaxes the export for eeh_dev_check_failure
> to make it consistent with eeh_check_failure() and 
> usable by non-GPL modules.

The GPL covers all derivative works. Tweaking this doesn't magically
allow you to use the feature in non GPL code. Your legal department can I
am sure explain in detail further.

Alan
