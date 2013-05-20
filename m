Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667Ab3ETTIK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 15:08:10 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:48264 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab3ETTIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 15:08:07 -0400
Message-ID: <519A7494.1050206@wwwdotorg.org>
Date: Mon, 20 May 2013 13:08:04 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Alexandre Courbot <gnurou@gmail.com>
CC: linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexandre Courbot <acourbot@nvidia.com>
Subject: Re: [PATCH] ARM: tegra: enable host1x support by default
References: <1368868666-24754-1-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1368868666-24754-1-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2013 03:17 AM, Alexandre Courbot wrote:
> Tegra DRM support used to be enabled in the default Tegra configuration,
> but it now depends on CONFIG_TEGRA_HOST1X which is disabled by default.
> Enable CONFIG_TEGRA_HOST1X so that DRM support is compiled in again.

I've forwarded this to arm@kernel.org in the hope it can be pulled into
3.10. If not, I'll apply it to the Tegra tree once I hear back.
