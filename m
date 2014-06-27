Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425AbaF0Rpb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 13:45:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42974 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbaF0Rp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 13:45:29 -0400
Date: Fri, 27 Jun 2014 10:49:40 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Joerg Roedel <joro@8bytes.org>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] iommu: Constify struct iommu_ops
Message-ID: <20140627174940.GB1653@kroah.com>
References: <1403852592-10637-1-git-send-email-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403852592-10637-1-git-send-email-thierry.reding@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 09:03:12AM +0200, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> This structure is read-only data and should never be modified.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
> Changes in v2:
> - add missing hunk from include/device.h
> 

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
