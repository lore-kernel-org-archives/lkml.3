Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbaIJRPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 13:15:19 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52028 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbaIJRPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 13:15:17 -0400
Message-ID: <541084D3.8030505@wwwdotorg.org>
Date: Wed, 10 Sep 2014 11:05:23 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Marcel Ziswiler <marcel@ziswiler.com>, alsa-devel@alsa-project.org
CC: linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, stefan@agner.ch
Subject: Re: [PATCH 1/3] ASoC: tegra: add tegra sgtl5000 machine driver
References: <cover.1410276224.git.marcel@ziswiler.com> <f90791ebb1799a4aa62dd6b527885ddadae3c058.1410276224.git.marcel@ziswiler.com>
In-Reply-To: <f90791ebb1799a4aa62dd6b527885ddadae3c058.1410276224.git.marcel@ziswiler.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2014 09:28 AM, Marcel Ziswiler wrote:
> This binding and driver describe/support playback to headphones, and
> capture from line-in and microphone.
>
> This driver is useful for the Toradex Apalis T30 and Colibri T30 modules.

Reviewed-by: Stephen Warren <swarren@nvidia.com>
