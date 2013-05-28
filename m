Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934582Ab3E1PT0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 11:19:26 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51940 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934474Ab3E1PTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 11:19:24 -0400
Message-ID: <51A4CAF9.4000305@wwwdotorg.org>
Date: Tue, 28 May 2013 09:19:21 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        gnurou@gmail.com
Subject: Re: [PATCH RESEND] ARM: tegra114: correctly output clk_32k
References: <1369536991-6111-1-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1369536991-6111-1-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/2013 08:56 PM, Alexandre Courbot wrote:
> Tegra has a blink timer register that allows to modulate the
> clk_32k clock before outputting it. Since clk_32k is presented to the
> kernel as a fixed clock, make sure this register does not tamper with
> the clock frequency and that clk_32k is outputted as-is, similarly to
> what is done on t20 and t30.

The patch subject here should be "clk: tegra:" rather than "ARM:
tegra114". I assume Mike can fix this up when applying it.
