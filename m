Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933596Ab3BLRqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 12:46:30 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:52931 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151Ab3BLRq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 12:46:28 -0500
Message-ID: <511A7FF1.1030009@wwwdotorg.org>
Date: Tue, 12 Feb 2013 10:46:25 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>, mturquette@linaro.org
CC: swarren@nvidia.com, pgaikwad@nvidia.com, pdeschrijver@nvidia.com,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH V2] clk: tegra: initialise parent of uart clocks
References: <1360682279-23051-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1360682279-23051-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2013 08:17 AM, Laxman Dewangan wrote:
> Initialise the parent of UARTs to PLLP and disabling clock by
> default.

This patch wasn't tested, was it? Without the patch I just sent titled
"ARM: tegra: remove clock-frequency properties from serial nodes", the
UART clocks get turned off and the console breaks.

Anyway, I've applied this patch to Tegra's for-3.9/soc-ccf-fixes branch
along with that other patch, although I'll hold off on pushing them out
while I wait for an ack from Mike on this patch, and give the other one
time to get reviews.
