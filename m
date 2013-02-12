Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933384Ab3BLTfE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 14:35:04 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:63971 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932293Ab3BLTfB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 14:35:01 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Stephen Warren <swarren@wwwdotorg.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <511A7FF1.1030009@wwwdotorg.org>
Cc: swarren@nvidia.com, pgaikwad@nvidia.com, pdeschrijver@nvidia.com,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
References: <1360682279-23051-1-git-send-email-ldewangan@nvidia.com>
 <511A7FF1.1030009@wwwdotorg.org>
Message-ID: <20130212193455.11471.39288@quantum>
User-Agent: alot/0.3.3+
Subject: Re: [PATCH V2] clk: tegra: initialise parent of uart clocks
Date: Tue, 12 Feb 2013 11:34:55 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stephen Warren (2013-02-12 09:46:25)
> On 02/12/2013 08:17 AM, Laxman Dewangan wrote:
> > Initialise the parent of UARTs to PLLP and disabling clock by
> > default.
> 
> This patch wasn't tested, was it? Without the patch I just sent titled
> "ARM: tegra: remove clock-frequency properties from serial nodes", the
> UART clocks get turned off and the console breaks.
> 
> Anyway, I've applied this patch to Tegra's for-3.9/soc-ccf-fixes branch
> along with that other patch, although I'll hold off on pushing them out
> while I wait for an ack from Mike on this patch, and give the other one
> time to get reviews.

Acked-by: Mike Turquette <mturquette@linaro.org>
