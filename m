Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764385Ab3DDSP7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 14:15:59 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39385 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764361Ab3DDSP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 14:15:57 -0400
Message-ID: <515DC35A.4030301@wwwdotorg.org>
Date: Thu, 04 Apr 2013 12:15:54 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Prashant Gaikwad <pgaikwad@nvidia.com>, mturquette@linaro.org
CC: linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: tegra: Fix cdev1 and cdev2 IDs
References: <1365066304-2327-1-git-send-email-pgaikwad@nvidia.com>
In-Reply-To: <1365066304-2327-1-git-send-email-pgaikwad@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2013 03:05 AM, Prashant Gaikwad wrote:
> Correct IDs for cdev1 and cdev2 are 94 and 93 respectively.

This looks OK, but needs to be split up before I can apply it.

The binding change and driver changes will be applied to Tegra's
for-3.10/clk branch, since that's where clk changes are going.

The DT changes will be applied to Tegra's for-3.10/dt branch, since
that's where most of the DT content that's being edited here was
actually added, this kernel cycle.

There's no dependency between these two sets of changes, since the
clocks properties for the sound and USB PHY nodes aren't actually used
by the drivers yet; they're just being added this kernel cycle to avoid
dependencies in the next kernel version.

Mike, can you please ack this patch anyway, and I'll repost later in the
day when I get around to splitting it up and applying it. Thanks.
