Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502Ab3DXCzc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 22:55:32 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13575 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756688Ab3DXCzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 22:55:31 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 23 Apr 2013 19:55:20 -0700
Subject: Re: [PATCH 06/21] ARM: tegra: call cpu_do_idle from C code
From: Joseph Lo <josephl@nvidia.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
In-Reply-To: <1366734653-488286-7-git-send-email-arnd@arndb.de>
References: <1366734653-488286-1-git-send-email-arnd@arndb.de>
	 <1366734653-488286-7-git-send-email-arnd@arndb.de>
Date: Wed, 24 Apr 2013 10:55:18 +0800
Message-ID: <1366772118.18275.2.camel@jlo-ubuntu-64.nvidia.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-24 at 00:30 +0800, Arnd Bergmann wrote:
> When building a kernel for multiple CPU architecture levels,
> cpu_do_idle() is a macro for an indirect function call, which
> cannot be called from assembly code as Tegra does.
> 
> Adding a trivial C wrapper for this function lets us build
> a tegra kernel with ARMv6 support enabled.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Joseph Lo <josephl@nvidia.com>
> Cc: Stephen Warren <swarren@nvidia.com>
> ---

Hi Arnd,

Thanks for fixing.

Tested-by: Joseph Lo <josephl@nvidia.com>

Joseph

