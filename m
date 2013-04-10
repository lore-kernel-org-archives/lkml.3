Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936996Ab3DJW3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:29:37 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:48865 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933050Ab3DJW3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:29:35 -0400
Message-ID: <5165E7CC.1010101@wwwdotorg.org>
Date: Wed, 10 Apr 2013 16:29:32 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: config: tegra: enable T114 SPI
References: <1365594483-20651-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1365594483-20651-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2013 05:48 AM, Laxman Dewangan wrote:
> Nvidia Tegra114 has the new spi controller whose driver
> is not compatible with older SoCs. The new driver is added
> for Tegra114 spi controller.

These 2, and the other 2 KBC patches you posted, all look reasonable.
They'll have to wait until 3.11 though.
