Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbaEFSOn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 14:14:43 -0400
Received: from 8bytes.org ([85.214.48.195]:33053 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbaEFSOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 14:14:42 -0400
Date: Tue, 6 May 2014 20:14:39 +0200
From: Joerg Roedel <joro@8bytes.org>
To: suravee.suthikulpanit@amd.com
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kim.naru@amd.com, jay.cornwall@amd.com
Subject: Re: [PATCH] iommu/amd: Take mmap_sem when calling get_user_pages
Message-ID: <20140506181438.GD12376@8bytes.org>
References: <1398724066-3730-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398724066-3730-1-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue May  6 20:14:40 2014
X-DSPAM-Confidence: 0.9987
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5369269020861716815794
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 05:27:46PM -0500, Suthikulpanit, Suravee wrote:
> From: Jay Cornwall <jay.cornwall@amd.com>
> 
> get_user_pages requires caller to hold a read lock on mmap_sem.

Right, but can't we just switch to get_user_pages_fast instead?


	Joerg


