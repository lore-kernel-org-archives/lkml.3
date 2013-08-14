Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760232Ab3HNUZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 16:25:24 -0400
Received: from 8bytes.org ([85.214.48.195]:51433 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758395Ab3HNUZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 16:25:22 -0400
Date: Wed, 14 Aug 2013 22:25:19 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Radmila =?iso-8859-1?Q?Kompov=E1?= <xkompo00@stud.fit.vutbr.cz>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] drivers/iommu/amd_iommu.c: fix resource leak in
 iommu_init_device()
Message-ID: <20130814202518.GB3493@8bytes.org>
References: <51828529.90900@stud.fit.vutbr.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51828529.90900@stud.fit.vutbr.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Aug 14 22:25:21 2013
X-DSPAM-Confidence: 0.9971
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 520be7b120862828082430
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 05:24:25PM +0200, Radmila Kompová wrote:
> Detected by cppcheck.
> 
> Signed-off-by: Kamil Dudka <kdudka@redhat.com>

Applied to x86/amd, thanks.


