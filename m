Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759879Ab3BYU5C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 15:57:02 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:45395 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759448Ab3BYU5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 15:57:00 -0500
Message-ID: <512BD015.5000200@wwwdotorg.org>
Date: Mon, 25 Feb 2013 13:56:53 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: arm@kernel.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, Julian Andres Klode <jak@jak-linux.org>,
        Marc Dietrich <marvin24@gmx.de>, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V4 2/2] MAINTAINERS: update Tegra section to capture all
 Tegra files
References: <1360629574-23989-1-git-send-email-swarren@wwwdotorg.org> <1360629574-23989-2-git-send-email-swarren@wwwdotorg.org>
In-Reply-To: <1360629574-23989-2-git-send-email-swarren@wwwdotorg.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2013 05:39 PM, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> The intent is to ensure that all Tegra-related patches are sent to the
> linux-tegra@ mailing list, so people can keep up-to-date on all misc
> driver changes.
> 
> Doing this with a keyword is far simpler and more compact than listing
> all Tegra-related drivers, even if wildcards were used.
> 
> Words such as integrate or integrator are common. Ensure the character
> right before "tegra" isn't a-z (case-insensitive), to make sure the
> keyword doesn't match those.
> 
> The only files that the keyword doesn't match are the NVEC driver. Add
> the linux-tegra mailing list to the NVEC entry to solve this.

Andrew, I see you've taken patch 1/2 into your tree. Are you planning on
taking patch 2/2 as well? Patch 2/2 depends on patch 1/2, so they really
should go through the same tree, or into different kernel versions or -rcs.

Thanks.
