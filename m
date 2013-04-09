Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936192Ab3DIU3q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 16:29:46 -0400
Received: from 8bytes.org ([85.214.48.195]:36475 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933489Ab3DIU3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 16:29:44 -0400
Date: Tue, 9 Apr 2013 22:29:42 +0200
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 7/9] iommu/amd: Add ioapic and hpet ivrs override
Message-ID: <20130409202941.GJ6858@8bytes.org>
References: <1365538384-12426-1-git-send-email-joro@8bytes.org>
 <1365538384-12426-8-git-send-email-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365538384-12426-8-git-send-email-joro@8bytes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Apr  9 22:29:42 2013
X-DSPAM-Confidence: 0.9991
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 51647a3623671885714295
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 10:13:02PM +0200, Joerg Roedel wrote:
> Add two new kernel commandline parameters ivrs_ioapic and
> ivrs_hpet to override the Id->DeviceId mapping from the IVRS
> ACPI table. This can be used to work around broken BIOSes to
> get interrupt remapping working on AMD systems.
> 
> Signed-off-by: Joerg Roedel <joro@8bytes.org>

Forgot to add:

Tested-by: Borislav Petkov <bp@suse.de>

