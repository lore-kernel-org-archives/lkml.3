Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbaBERR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 12:17:57 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:41868 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055AbaBERRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 12:17:55 -0500
Message-ID: <52F27240.7000201@wwwdotorg.org>
Date: Wed, 05 Feb 2014 10:17:52 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: tegra: add system-power-controller property for
 PMIC node
References: <1389265308-26405-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1389265308-26405-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2014 04:01 AM, Laxman Dewangan wrote:
> Add system-power-controller property to system PMIC, ams AS3722,
> node to enable power off functionality through PMIC.

Applied to Tegra's for-3.15/dt branch.

