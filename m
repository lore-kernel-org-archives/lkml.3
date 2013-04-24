Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394Ab3DXRyl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 13:54:41 -0400
Received: from 8bytes.org ([85.214.48.195]:56469 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755883Ab3DXRyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 13:54:40 -0400
Date: Wed, 24 Apr 2013 19:54:35 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Linn Crosetto <linn@hp.com>
Cc: mingo@kernel.org, ddutile@redhat.com, suresh.b.siddha@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iommu: dmar -- remove warning for HPET scope type
Message-ID: <20130424175434.GA3167@8bytes.org>
References: <1366741605-71293-1-git-send-email-linn@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366741605-71293-1-git-send-email-linn@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Apr 24 19:54:38 2013
X-DSPAM-Confidence: 0.9991
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 51781c5e23671778620327
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 12:26:45PM -0600, Linn Crosetto wrote:
> ACPI_DMAR_SCOPE_TYPE_HPET is parsed by ir_parse_ioapic_hpet_scope() and
> should not be flagged as an unsupported type.
> 
> Signed-off-by: Linn Crosetto <linn@hp.com>

Applied to x86/vt-d, thanks.


