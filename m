Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab3FFQFc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 12:05:32 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55922 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414Ab3FFQFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 12:05:31 -0400
Message-ID: <51B0B347.7010807@wwwdotorg.org>
Date: Thu, 06 Jun 2013 10:05:27 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: linux-arm-kernel@lists.infradead.org, mturquette@linaro.org,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] Override bits for PLLM
References: <1370515677-6807-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1370515677-6807-1-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2013 04:47 AM, Peter De Schrijver wrote:
> PLLM has override bits on Tegra30 and Tegra114. This patchset implements
> support for them for both Tegra30 and Tegra114.
> 
> Changes since v1:
>  * Remove some stray lines from 'clk: tegra: override bits for Tegra114 PLLM'

Recall that for V1, I said:

Tested-by: Stephen Warren <swarren@nvidia.com>
Acked-by: Stephen Warren <swarren@nvidia.com>

(assuming the one comment I already made is fixed)

(and according to the changelog above, it has been)
