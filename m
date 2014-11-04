Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbaKDOE1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 09:04:27 -0500
Received: from 8bytes.org ([81.169.241.247]:33929 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753822AbaKDOEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 09:04:25 -0500
Date: Tue, 4 Nov 2014 15:04:22 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Kiran Padwal <kiran.padwal@smartplayin.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] msm: iommu: use dev_get_platdata()
Message-ID: <20141104140422.GB14512@8bytes.org>
References: <1414650311-24211-1-git-send-email-kiran.padwal@smartplayin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414650311-24211-1-git-send-email-kiran.padwal@smartplayin.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 11:55:11AM +0530, Kiran Padwal wrote:
> Use the wrapper function for retrieving the platform data instead of
> accessing dev->platform_data directly.
> 
> Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>

Applied to arm/msm, thanks.
