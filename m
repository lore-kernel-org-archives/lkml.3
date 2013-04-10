Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935620Ab3DJQDH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 12:03:07 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:43533 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab3DJQDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 12:03:06 -0400
MIME-Version: 1.0
In-Reply-To: <1365538384-12426-2-git-send-email-joro@8bytes.org>
References: <1365538384-12426-1-git-send-email-joro@8bytes.org>
	<1365538384-12426-2-git-send-email-joro@8bytes.org>
Date: Wed, 10 Apr 2013 10:03:03 -0600
Message-ID: <CAKocOOMdFyzBgOrsU3iu6Uj0f7Hk373FXrWfMkFP89LaKw0xaw@mail.gmail.com>
Subject: Re: [PATCH 1/9] iommu/amd: Remove map_sg_no_iommu()
From: Shuah Khan <shuahkhan@gmail.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 9, 2013 at 2:12 PM, Joerg Roedel <joro@8bytes.org> wrote:
> This function was intended as a fall-back if the map_sg
> function is called for a device not mapped by the IOMMU.
> Since the AMD IOMMU driver uses per-device dma_ops this can
> never happen. So this function isn't needed anymore.
>
> Signed-off-by: Joerg Roedel <joro@8bytes.org>
> ---

Reviewed-by: Shuah Khan <shuahkhan@gmail.com>
