Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab3LFIhv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 03:37:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624Ab3LFIht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 03:37:49 -0500
Date: Fri, 6 Dec 2013 09:39:34 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v3 00/11] Introduce pcim_enable_msi*() family helpers
Message-ID: <20131206083934.GA17949@dhcp-26-207.brq.redhat.com>
References: <cover.1385399393.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1385399393.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 10:09:49AM +0100, Alexander Gordeev wrote:
> Patches 3,4	- fixes for PowerPC pSeries platform
[...]
>   PCI/MSI/pSeries: Fix wrong error code reporting
>   PCI/MSI/pSeries: Make quota traversing and requesting race-safe

Hi Bjorn,

The two unreviewed PowerPC patches is not a blocker for the rest of the
series as they are completely independent with the rest of the changes.
I can rework them later if needed.

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
