Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758693Ab3BLXKD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 18:10:03 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:41328 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642Ab3BLXKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 18:10:00 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] kbuild: limit dtc+cpp include path
To: Stephen Warren <swarren@wwwdotorg.org>,
        Rob Herring <rob.herring@calxeda.com>
Cc: devicetree-discuss@lists.ozlabs.org, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
In-Reply-To: <1360706617-20276-1-git-send-email-swarren@wwwdotorg.org>
References: <1360706617-20276-1-git-send-email-swarren@wwwdotorg.org>
Date: Tue, 12 Feb 2013 23:09:55 +0000
Message-Id: <20130212230955.5E5B93E240D@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2013 15:03:37 -0700, Stephen Warren <swarren@wwwdotorg.org> wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> Device tree source files may now include header files. The intent is
> that those header files define/name constants used as part of the DT
> bindings. Currently this feature is open to abuse, since any kernel
> header file at all can be included, This could allow device tree files
> to become dependant on kernel headers files, and thus make them no
> longer OS-independent. This would also prevent separating the device
> tree source files from the kernel repository.
> 
> Solve this by limiting the cpp include path for device tree files to
> separate directories.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> Here, I allow header files in the .dts source directory, or in a per-arch
> include directory. Perhaps rather than:
> 
> -I$(srctree)/arch/$(SRCARCH)/include/dts

That seems reasonable for now.

Applied, thanks.
g.

