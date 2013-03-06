Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040Ab3CFUkL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 15:40:11 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:53557 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab3CFUkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 15:40:09 -0500
Message-ID: <5137A9A5.1040403@wwwdotorg.org>
Date: Wed, 06 Mar 2013 13:40:05 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: linux-tegra@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, Joseph Lo <josephl@nvidia.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: tegra: No 7.1 super clk dividers on Tegra20
References: <1360327453-29242-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1360327453-29242-1-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2013 05:44 AM, Peter De Schrijver wrote:
> Unlike Tegra30, Tegra20 does not have a 7.1 divider for the CPU superclk.
> Remove the clocks related to the divider.

I have applied this to Tegra's for-3.10/fixes branch.
