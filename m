Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab3AURLr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 12:11:47 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:44281 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052Ab3AURLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 12:11:46 -0500
Message-ID: <50FD76CD.2020400@wwwdotorg.org>
Date: Mon, 21 Jan 2013 10:11:41 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linux@arm.linux.org.uk, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: tegra: DTS: seaboard: remove unnecessarily text
References: <1358588264-1860-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1358588264-1860-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2013 02:37 AM, Laxman Dewangan wrote:
> There is unnecessarily text in the keymap table. Removing this.

Thanks, I just squashed this into your original patch.
