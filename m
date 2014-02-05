Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbaBEQFS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 11:05:18 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:36807 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489AbaBEQFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 11:05:16 -0500
Message-ID: <52F26138.60300@wwwdotorg.org>
Date: Wed, 05 Feb 2014 09:05:12 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>, linus.walleij@linaro.org
CC: thierry.reding@gmail.com, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pinctrl: tegra: return correct error type
References: <1391607694-8608-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1391607694-8608-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2014 06:41 AM, Laxman Dewangan wrote:
> When memory allocation failed, drive should return error as ENOMEM.

Acked-by: Stephen Warren <swarren@nvidia.com>

