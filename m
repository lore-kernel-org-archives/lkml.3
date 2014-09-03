Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbaICL53 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 07:57:29 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:42606 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932067AbaICL52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 07:57:28 -0400
Message-ID: <54070234.30201@mm-sol.com>
Date: Wed, 03 Sep 2014 14:57:40 +0300
From: Georgi Djakov <gdjakov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>
CC: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Asutosh Das <asutoshd@codeaurora.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>
Subject: Re: [PATCH] mmc: sdhci-msm: Make tuning block table endian agnostic
References: <1409702308-3023-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1409702308-3023-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2014 02:58 AM, Stephen Boyd wrote:
> If we're tuning on a big-endian CPU we'll never determine we properly
> tuned the device because we compare the data we received from the
> controller with a table that assumes the CPU is little-endian.
> Change the table to be an array of bytes instead of 32-bit words
> so we can use memcmp() without needing to byte-swap every word
> depending on the endianess of the CPU.
> 
> Cc: Asutosh Das <asutoshd@codeaurora.org>
> Cc: Venkat Gopalakrishnan <venkatg@codeaurora.org>
> Cc: Georgi Djakov <gdjakov@mm-sol.com>
> Fixes: 415b5a75da43 "mmc: sdhci-msm: Add platform_execute_tuning implementation"
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---

Looks nice. Thanks!

Reviewed-by: Georgi Djakov <gdjakov@mm-sol.com>
