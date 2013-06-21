Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423193Ab3FUPPF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 11:15:05 -0400
Received: from 8bytes.org ([85.214.48.195]:37029 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161367Ab3FUPPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 11:15:04 -0400
Date: Fri, 21 Jun 2013 17:15:00 +0200
From: Joerg Roedel <joro@8bytes.org>
To: suravee.suthikulpanit@amd.com
Cc: iommu@lists.linux-foundation.org, ddutile@redhat.com,
        alex.williamson@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] iommu/amd: IOMMU Error Reporting/Handling/Filtering
Message-ID: <20130621151459.GK11309@8bytes.org>
References: <1369250155-12226-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369250155-12226-1-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Jun 21 17:15:01 2013
X-DSPAM-Confidence: 0.9990
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 51c46df520863344619793
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 02:15:52PM -0500, Suthikulpanit, Suravee wrote:
> From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> 
> This patch set implements framework for handling errors reported via IOMMU 
> event log. It also implements mechanism to filter/suppress error messages when 
> IOMMU hardware generates large amount event logs, which is often caused by 
> devices performing invalid operations or from misconfiguring IOMMU hardware 
> (e.g. IO_PAGE_FAULT and INVALID_DEVICE_QEQUEST").

Instead of extending this bad scaling dmesg error-reporting mechanism, I
would very much like to see an integration of IOMMU error handling into
the EDAC framework.

An exception is of course still the flags decoding in this patch-set.
This alone would be pretty compelling as long as there is no integration
into EDAC.


	Joerg


