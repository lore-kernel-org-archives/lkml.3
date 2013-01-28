Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757716Ab3A1SEY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 13:04:24 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:43875 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757621Ab3A1SEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 13:04:23 -0500
Message-ID: <5106BDA3.8090009@wwwdotorg.org>
Date: Mon, 28 Jan 2013 11:04:19 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: linux-tegra@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Olof Johansson <olof@lixom.net>, Jason Cooper <jason@lakedaemon.net>,
        Shawn Guo <shawn.guo@linaro.org>, Andrew Lunn <andrew@lunn.ch>,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [v4 1/6] ARM: tegra: Use DT /cpu node to detect number of CPU
 core
References: <1359025829-22306-1-git-send-email-hdoyu@nvidia.com> <1359025829-22306-2-git-send-email-hdoyu@nvidia.com>
In-Reply-To: <1359025829-22306-2-git-send-email-hdoyu@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2013 04:10 AM, Hiroshi Doyu wrote:
> Tegra SoCs does not use SCU based to detect CPU core numbers but they
> use DT /cpu node. If it's not provided or failed, it continues as a
> single core.

I've applied patch 1 to Tegra's for-3.9/scu-base-rework branch, and
patches 2-6 to Tegra's for-3.9/soc-t114 branch.
