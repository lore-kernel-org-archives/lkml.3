Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbaESVQh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 17:16:37 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:43019 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbaESVQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 17:16:35 -0400
Message-ID: <537A74B0.604@wwwdotorg.org>
Date: Mon, 19 May 2014 15:16:32 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>, Ben Skeggs <bskeggs@redhat.com>,
        Thierry Reding <thierry.reding@gmail.com>
CC: nouveau@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        gnurou@gmail.com, Thierry Reding <treding@nvidia.com>
Subject: Re: [PATCH 3/5] ARM: tegra: add GK20A GPU to Tegra124 DT
References: <1400491450-19223-1-git-send-email-acourbot@nvidia.com> <1400491450-19223-4-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1400491450-19223-4-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2014 03:24 AM, Alexandre Courbot wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> Add the GK20A device node to Tegra124's device tree.

At a quick glance, patches 3-5 look fine too. I'll hold off on applying
them until patches 1-2 have been applied to the DRM/... tree.
