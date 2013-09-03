Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760283Ab3ICR5K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 13:57:10 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46340 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760262Ab3ICR5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 13:57:08 -0400
Message-ID: <522622F1.70008@wwwdotorg.org>
Date: Tue, 03 Sep 2013 11:57:05 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: linux-tegra@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        Joseph Lo <josephl@nvidia.com>, Paul Walmsley <pwalmsley@nvidia.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: tegra: replace enum tegra114_clk by binding header
References: <1378213915-10222-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1378213915-10222-1-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2013 07:11 AM, Peter De Schrijver wrote:
> As the clock IDs are now specified in a header file, we can use those
> definitions instead of maintaining an internal enum.

Acked-by: Stephen Warren <swarren@nvidia.com>

I assume this will go through Mike's clock tree for 3.13.

I assume similar patches will follow for Tegra20/30?
