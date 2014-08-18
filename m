Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917AbaHRQ5z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 12:57:55 -0400
Received: from 8bytes.org ([81.169.241.247]:38795 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbaHRQ5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 12:57:52 -0400
Date: Mon, 18 Aug 2014 18:57:50 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: iommu@lists.linux-foundation.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] iommu: Implement a dummy bus_set_iommu()
Message-ID: <20140818165750.GE9809@8bytes.org>
References: <1406897113-20099-1-git-send-email-thierry.reding@gmail.com>
 <1406897113-20099-2-git-send-email-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406897113-20099-2-git-send-email-thierry.reding@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2014 at 02:45:13PM +0200, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> This allows IOMMU drivers to compile even if IOMMU_API is not selected
> and helps improve compile coverage.

IOMMU drivers usually implement the IOMMU-API, so they have a strong
dependency to it. Why do you want to compile-test an iommu driver
without testing the iommu core-code as well?


	Joerg

