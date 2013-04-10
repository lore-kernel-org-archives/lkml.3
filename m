Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936876Ab3DJQDv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 12:03:51 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:42150 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755531Ab3DJQDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 12:03:50 -0400
MIME-Version: 1.0
In-Reply-To: <1365538384-12426-3-git-send-email-joro@8bytes.org>
References: <1365538384-12426-1-git-send-email-joro@8bytes.org>
	<1365538384-12426-3-git-send-email-joro@8bytes.org>
Date: Wed, 10 Apr 2013 10:03:48 -0600
Message-ID: <CAKocOOM3T2Dr6etRT6rjiYp3va9P3jspaDaQjWJMM-WC3rwEog@mail.gmail.com>
Subject: Re: [PATCH 2/9] iommu/amd: Use AMD specific data structure for irq remapping
From: Shuah Khan <shuahkhan@gmail.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 9, 2013 at 2:12 PM, Joerg Roedel <joro@8bytes.org> wrote:
> For compatibility reasons the irq remapping code for the AMD
> IOMMU used the same per-irq data structure as the Intel
> implementation. Now that support for the AMD specific data
> structure is upstream we can use this one instead.
>
> Signed-off-by: Joerg Roedel <joro@8bytes.org>
> ---

Reviewed-by: Shuah Khan <shuahkhan@gmail.com>
