Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288AbbAIMD0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 07:03:26 -0500
Received: from 8bytes.org ([81.169.241.247]:60310 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932077AbbAIMDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 07:03:23 -0500
Date: Fri, 9 Jan 2015 13:03:21 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Yinghai Lu <yinghai@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [Patch v2 00/16] Refine IR initialization flow and fixes bugs
 related to X2APIC
Message-ID: <20150109120321.GA17298@8bytes.org>
References: <1420615903-28253-1-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420615903-28253-1-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2015 at 03:31:27PM +0800, Jiang Liu wrote:
> This patch set is based on v3.19-rc3. And you may access it at:
> https://github.com/jiangliu/linux.git ir_init_v2

I tested this branch on an AMD system, everything looks good so far. I
couldn't find any regressions. So feel free to add my

Tested-by: Joerg Roedel <jroedel@suse.de>


Regards,

	Joerg

