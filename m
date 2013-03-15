Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876Ab3COFXl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 01:23:41 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55017 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab3COFXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 01:23:39 -0400
Message-ID: <5142B05A.2070408@wwwdotorg.org>
Date: Thu, 14 Mar 2013 23:23:38 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] amba: tegra-ahb: Fix build error w/ PM_SLEEP w/o
 PM_RUNTIME
References: <1363252089-4120-1-git-send-email-hdoyu@nvidia.com>
In-Reply-To: <1363252089-4120-1-git-send-email-hdoyu@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2013 03:08 AM, Hiroshi Doyu wrote:
> Make this depend on CONFIG_PM. This protection is necessary to not
> cause any build errors with any combination of PM features especially
> when supporting a new SoC where each PM features are being enabled
> one-by-one during its depelopment.

Looks fine to me.

Acked-by: Stephen Warren <swarren@nvidia.com>

I assume Russell will want this to go through his patch tracker.
