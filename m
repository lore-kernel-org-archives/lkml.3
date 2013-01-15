Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997Ab3AOTBA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 14:01:00 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:43287 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757270Ab3AOS7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:59:18 -0500
Message-ID: <50F5A6FC.4090104@wwwdotorg.org>
Date: Tue, 15 Jan 2013 11:59:08 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linux@arm.linux.org.uk, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ARM: DT: tegra: add DT entry for KBC controller
References: <1357911185-11048-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1357911185-11048-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2013 06:33 AM, Laxman Dewangan wrote:
> NVIDIA's Tegra SoCs have the matrix keyboard controller which
> supports 16x8 type of matrix. The number of rows and columns
> are configurable.
> 
> Add DT entry for KBC controller.

Applied to Tegra's for-3.9/dt branch.

I added the required clocks property for this patch to work with
Prashant's common clock framework port, although it's commented out so
far, until the CCF rework is actually applied.
