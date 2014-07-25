Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758632AbaGYSlk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 14:41:40 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46136 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310AbaGYSlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 14:41:37 -0400
Message-ID: <53D2A4DE.7010301@wwwdotorg.org>
Date: Fri, 25 Jul 2014 12:41:34 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Marcel Ziswiler <marcel@ziswiler.com>, thierry.reding@gmail.com
CC: linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, stefan@agner.ch
Subject: Re: [PATCH] ARM: tegra: apalis t30: fix device tree compatible node
References: <aa2cbaac07707c3d64599d3841b9d6f77567a91f.1406081870.git.marcel@ziswiler.com>
In-Reply-To: <aa2cbaac07707c3d64599d3841b9d6f77567a91f.1406081870.git.marcel@ziswiler.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2014 08:23 PM, Marcel Ziswiler wrote:
> Working on sound support I noticed the Apalis T30 Evaluation board
> device tree missing the more generic Apalis T30 compatible string.

I've forwarded this patch to the arm-soc maintainers to apply directly.
