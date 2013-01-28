Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757693Ab3A1SDs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 13:03:48 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:48886 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757603Ab3A1SDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 13:03:46 -0500
Message-ID: <5106BD7E.6020805@wwwdotorg.org>
Date: Mon, 28 Jan 2013 11:03:42 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: linux-arm-kernel@lists.infradead.org, arnd@arndb.de, olof@lixom.net,
        santosh.shilimkar@ti.com, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [v3 1/2] ARM: Add API to detect SCU base address from CP15
References: <1358833924-24535-1-git-send-email-hdoyu@nvidia.com>
In-Reply-To: <1358833924-24535-1-git-send-email-hdoyu@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2013 10:52 PM, Hiroshi Doyu wrote:
> Add API to detect SCU base address from CP15.

I've applied these 2 patches and Santosh's OMAP followup to Tegra's
for-3.9/scu-base-rework branch.
