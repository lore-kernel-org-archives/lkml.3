Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560Ab3A1Sta (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 13:49:30 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:60841 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab3A1St3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 13:49:29 -0500
Message-ID: <5106C836.2040301@wwwdotorg.org>
Date: Mon, 28 Jan 2013 11:49:26 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH] arm: tegra: dt: Add reset GPIO information to PHY DT
 node
References: <1359022606-13359-1-git-send-email-vbyravarasu@nvidia.com>
In-Reply-To: <1359022606-13359-1-git-send-email-vbyravarasu@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2013 03:16 AM, Venu Byravarasu wrote:
> As reset GPIO information is PHY specific detail, adding
> it to PHY DT node.

I have applied this to Tegra's for-3.9/soc-usb branch.

A couple minor notes: Changes to DT binding definitions should really be
sent to the devicetree-discuss mailing list. I didn't insist on that
here since the change is fairly minor. Also, the Linux ARM kernel
mailing list is possibly more useful than the main Linux kernel mailing
list for ARM-/Tegra-specific patches like this.
