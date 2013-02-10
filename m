Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760524Ab3BJSoD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 13:44:03 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:34780 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759010Ab3BJSoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 13:44:01 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] gpiolib: fix link error when sysfs is not built
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, gnurou@gmail.com,
        Alexandre Courbot <acourbot@nvidia.com>
In-Reply-To: <1360504821-13110-1-git-send-email-gnurou@gmail.com>
References: <CACxGe6tAEX7o9dxNTXtwKwzZHmEteKAS+7uy4j-DTX_2V583tg@mail.gmail.com> <1360504821-13110-1-git-send-email-gnurou@gmail.com>
Date: Sun, 10 Feb 2013 18:43:59 +0000
Message-Id: <20130210184359.5FE083E10AE@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Feb 2013 23:00:21 +0900, Alexandre Courbot <gnurou@gmail.com> wrote:
> From: Alexandre Courbot <acourbot@nvidia.com>
> 
> Fix all compilation errors and warnings triggered by my latest series of
> patch on Grant's linux-next branch. Please meld this patch into the culprit
> one to avoid ending with a commit that breaks compilation in the git history.
> 
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>

Applied, thanks. I've pushed it out as a separate commit since I had
already pushed my tree out. so I need to make sure linusw hasn't pulled
it and applied anything on top before I respin.

g.

