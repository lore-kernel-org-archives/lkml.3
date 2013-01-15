Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072Ab3AOS7s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 13:59:48 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:51461 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757534Ab3AOS7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:59:45 -0500
Message-ID: <50F5A71F.7010108@wwwdotorg.org>
Date: Tue, 15 Jan 2013 11:59:43 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linux@arm.linux.org.uk, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3 RFT] ARM: tegra: dts: seaboard: enable keyboard
References: <1358234689-18126-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1358234689-18126-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2013 12:24 AM, Laxman Dewangan wrote:
> Enable tegra based keyboard controller and populate the key matrix for
> seaboard. The key matrix was originally on driver code which is removed
> to have clean driver. The key mapping is now passed through dts file.

Applied to Tegra's for-3.9/dt branch.
